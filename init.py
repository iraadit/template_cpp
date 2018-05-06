#!/bin/env python3

from abc import ABC, abstractmethod

import sys
import queue
import os
import configparser
import re
import getpass
import datetime
import glob


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


class ReReplaceTask(InitTask):
        """ReReplaceTask is the task for replacement using regular expressions.
        """
        def __init__(self, filename, oregex, nval):
                self._filename = filename
                self._oregex = oregex
                self._nval = nval

        def exec(self):
                """Replaces the strings matching the oregex with the new value.
                """
                with open(self._filename, "r+") as f:
                        s = f.read()
                        s = re.sub(self._oregex, self._nval, s)
                        f.seek(0)
                        f.write(s)
                        f.truncate()


class MoveTask(InitTask):
        """MoveTask is the task for moving files and directories."""
        def __init__(self, ofile, nfile):
                self._ofile = ofile
                self._nfile = nfile

        def exec(self):
                """Moves the old file/dir to new file/dir."""
                os.rename(self._ofile, self._nfile)


class DeleteTask(InitTask):
        """DeleteTask is the task for deleting files and directories."""
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

print("Initializing the template.")

# basic project info
cmakelist = os.path.join(scp_dir, "CMakeLists.txt")
pname = def_input("Project name", prj_dir)
taskq.put(ReReplaceTask(cmakelist, "__PROJECT_NAME__", pname))

author = def_input("Project author", config['name'])
taskq.put(ReReplaceTask(cmakelist, "__AUTHOR__", author))

mail = def_input("Project email", config['email'])
taskq.put(ReReplaceTask(cmakelist, "__AUTHOR_MAIL__", mail))

version = def_input("Project version", "1.0.0")
taskq.put(ReReplaceTask(cmakelist, "0.0.0", version))

copyright = def_input("Copyright", "%s, %s" %
                      (datetime.datetime.now().year,  author))
taskq.put(ReReplaceTask(cmakelist, "__COPYRIGHT__", copyright))

description = def_input("Description", prj_dir)
taskq.put(ReReplaceTask(cmakelist, "__DESCRIPTION__", description))

# gitlab ci
use_ci = def_input("Use gitlab ci?", "yes")
gitlabci = os.path.join(scp_dir, ".gitlab-ci.yml")
if use_ci == "yes":
        # get new registry url
        dockertarget = os.path.join(scp_dir, "./ci/docker_targets")
        ver_cur = ":[0-9]\.[0-9]"
        ver_new = ":1.0"
        reg_domain = req_input("Docker registry domain")
        reg_port = req_input("Docker registry port")
        gitlab_group = req_input("Gitlab group/user name")
        org_url = "git.mel.vin:5005/template/c"
        new_url = "%s:%s/%s/%s" % (reg_domain, reg_port, gitlab_group, pname)

        # update urls
        taskq.put(ReReplaceTask(gitlabci, org_url, new_url))
        taskq.put(ReReplaceTask(gitlabci, ver_cur, ver_new))

        # update image registry location
        for root, dirs, files in os.walk(dockertarget):
                for f in (file for file in files if file == "Tagfile"):
                        full_path = os.path.join(root, f)
                        taskq.put(ReReplaceTask(full_path, org_url, new_url))
                        taskq.put(ReReplaceTask(full_path, ver_cur, ver_new))
else:
        taskq.put(DeleteTask(gitlabci))

# update all code reference to c template
sfiles = glob.glob("**/*.cpp", recursive=True) \
        + glob.glob("**/*.c", recursive=True) \
        + glob.glob("**/*.h", recursive=True)
for file in sfiles:
        full_path = os.path.join(scp_dir, file)
        taskq.put(ReReplaceTask(full_path, "c_template", pname))

# move project include dir
oldinclude = os.path.join(scp_dir, './include/c_template')
newinclude = os.path.join(scp_dir, './include/%s' % pname)
taskq.put(MoveTask(oldinclude, newinclude))

# delete c template descriptive files
taskq.put(DeleteTask(os.path.join(scp_dir, 'README.md')))
taskq.put(DeleteTask(os.path.join(scp_dir, 'CHANGELOG.md')))
taskq.put(DeleteTask(os.path.join(scp_dir, 'LICENCE')))

# confirmation
confirm = def_input("Apply selected values?", "yes")
if confirm == "yes":
        while not taskq.empty():
                taskq.get().exec()
