#!/bin/env python3

from abc import ABC, abstractmethod

import sys
import queue
import os
import configparser
import re
import getpass
import datetime


def uconfig():
        """Returns user configuration"""
        res = {}
        gitconfig = os.path.join(os.path.expanduser("~"), ".gitconfig")
        if os.path.exists(gitconfig):
                config = configparser.ConfigParser()
                config.read(gitconfig)
                res["name"] = config["user"]["name"]
                res["email"] = config["user"]["email"]
        else:
                res["name"] = getpass.getuser()
                res["email"] = ""

        return res


def req_input(question):
        """Returns user input which is given as an answer to the question.
        Answer is required.

        :param question: question to display
        """
        res = ""
        while not res or res.isspace():
                res = input("%s (Required): " % question)

        return res


def def_input(question, default):
        """Returns user input which is given as an answer to the question.
        Default is returned if no input is given.

        :param question: question to display
        :param default: default value
        """
        res = input("%s [%s]: " % (question, default))
        if not res or res.isspace():
                res = default

        return res


class InitTask(ABC):
        """InitTask is the base class for tasks."""
        @abstractmethod
        def exec(self):
                pass


class ReplaceTask(InitTask):
        """ReplaceTask is the task for replacing strings in files"""
        def __init__(self, filename, old_val, new_val):
                self._filename = filename
                self._old_val = old_val
                self._new_val = new_val

        def exec(self):
                """Replaces the old value with the new value in the given
                file.
                """
                with open(self._filename, "r+") as f:
                        s = f.read()
                        if self._old_val not in s:
                                raise Exception("%s not found in %s."
                                                % (self._old_val,
                                                   self._filename))

                        s = s.replace(self._old_val, self._new_val)
                        f.seek(0)
                        f.write(s)
                        f.truncate()


class DeleteTask(InitTask):
        """ReplaceTask is the task for deleting files and directories"""
        def __init__(self, filename):
                self._filename = filename

        def exec(self):
                """Deletes the given file or directory."""
                if not os.path.exists(self._filename):
                        return

                if os.path.isdir(self._filename):
                        os.rmdir(self._filename)
                else:
                        os.remove(self._filename)


# base variables
scp_dir = os.path.dirname(os.path.abspath(__file__))
prj_dir = os.path.basename(scp_dir)
taskq = queue.Queue()
config = uconfig()
cmakelist = os.path.join(scp_dir, "CMakeLists.txt")
gitlabci = os.path.join(scp_dir, ".gitlab-ci.yml")
dockertarget = os.path.join(scp_dir, "./ci/docker_targets")

print("Initializing the template.")

# basic project info
pname = def_input("Project name", prj_dir)
taskq.put(ReplaceTask(cmakelist, "__PROJECT_NAME__", pname))

author = def_input("Project author", config['name'])
taskq.put(ReplaceTask(cmakelist, "__AUTHOR__", author))

mail = def_input("Project email", config['email'])
taskq.put(ReplaceTask(cmakelist, "__AUTHOR_MAIL__", mail))

version = def_input("Project version", "1.0.0")
taskq.put(ReplaceTask(cmakelist, "0.0.0", version))

copyright = def_input("Copyright", "%s, %s" %
                      (datetime.datetime.now().year,  author))
taskq.put(ReplaceTask(cmakelist, "__COPYRIGHT__", copyright))

description = def_input("Description", prj_dir)
taskq.put(ReplaceTask(cmakelist, "__DESCRIPTION__", description))

# gitlab ci
use_ci = def_input("Use gitlab ci?", "yes")
if use_ci == "yes":
        # get new registry url
        reg_domain = req_input("Docker registry domain")
        reg_port = req_input("Docker registry port")
        gitlab_group = req_input("Gitlab group/user name")
        or_url = "git.mel.vin:5005/template/c"
        url = "%s:%s/%s/%s" % (reg_domain, reg_port, gitlab_group, pname)
        taskq.put(ReplaceTask(gitlabci, or_url, url))

        # update image registry location
        for root, dirs, files in os.walk(dockertarget):
                for f in (file for file in files if file == "Tagfile"):
                        full_path = os.path.join(root, f)
                        taskq.put(ReplaceTask(full_path, or_url, url))
else:
        taskq.put(DeleteTask(gitlabci))

# confirmation
confirm = def_input("Apply selected values?", "yes")
if confirm == "yes":
        while not taskq.empty():
                taskq.get().exec()
