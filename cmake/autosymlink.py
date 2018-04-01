#!/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function

import argparse
import os
import sys
import time
import logging
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# small hackerino for windows
if os.name == 'nt':
	import ctypes
	import subprocess
	win = ctypes.windll

	def win32_create_symlink(src, dst):
		# Set flags for the file or dir and then send the flag to allow
		# creation without admin permission
		flags = 1 if src is not None and os.path.isdir(src) else 0
		flags = flags | 2
		res = win.kernel32.CreateSymbolicLinkW(
			unicode(dst), unicode(src), flags)
		if not res:
			raise OSError(str(win.kernel32.GetLastError()))

	def win32_is_symlink(path):
		if not os.path.exists(path):
			return False

		FILE_ATTRIBUTE_REPARSE_POINT = 0x0400
		win32 = ctypes.windll.kernel32
		attributes = win.kernel32.GetFileAttributesW(
			unicode(path))
		return (attributes 
			& FILE_ATTRIBUTE_REPARSE_POINT) > 0

	def win32_unlink(path):
		if os.path.islink(path) is False:
			raise Exception("unlink only possible with symlink.")

		if os.path.isdir(path):
			os.rmdir(path)
		else:
			os.remove(path)

	os.symlink = win32_create_symlink
	os.path.islink = win32_is_symlink
	os.unlink = win32_unlink

class SymlinkHandler(FileSystemEventHandler):
	def __init__(self, rootpath, symlinkdir, quiet):
		self.rootpath = rootpath
		self.symlinkdir = symlinkdir
		self.quiet = quiet
		for n in os.listdir(self.symlinkdir):
			path = os.path.abspath(os.path.join(symlinkdir, n))
			print(path + "islink:" + str(os.path.islink(path)))
			if os.path.islink(path):
				msg = """Removing existing \
symlink: %s""" % (path)
				self.log(msg)
				os.unlink(path)
			else:
				msg = """Existing file in destdir \
that is not symlink: %s""" % (path)
				print(msg, file=sys.stderr)

		for n in os.listdir(rootpath):
			try:
				path = os.path\
					.abspath(os.path.join(rootpath, n))
				msg = """Creating initial \
symlink: %s""" % (path)
				self.log(msg)
				self.create_link(path)
			except Exception as e:
				print('Failed to create symlink: %s'
					% (str(e)),
					file=sys.stderr)

	def on_moved(self, event):
		msg = """Move detected: %s -> %s, \
Removing old symlink and creating new\
""" % (event.src_path, event.dest_path)
		self.log(msg)
		try:
			self.delete_link(event.src_path)
			self.create_link(event.dest_path)
		except Exception as e:
			print('Failed to remove or create symlink: %s'
				% (str(e)),
				file=sys.stderr)

	def on_created(self, event):
		msg = 'Create detected: %s, Creating symlink' % (event.src_path)
		self.log(msg)
		try:
			self.create_link(event.src_path)
		except Exception as e:
			print('Failed to create symlink: %s'
				% (str(e)),
				file=sys.stderr)

	def on_deleted(self, event):
		msg = 'Delete detected: %s, Deleting symlink' % (event.src_path)
		self.log(msg)
		try:
			self.delete_link(event.src_path)
		except Exception as e:
			print('Failed to create symlink: %s'
				% (str(e)),
				file=sys.stderr)

	def on_modified(self, event):
		msg = 'Change detected: %s, Recreating symlink' % \
			(event.src_path)
		self.log(msg)

		abssrc = os.path.normpath(os.path.abspath(event.src_path))

		if not abssrc.startswith(self.rootpath):
			print('Detected change is not within rootdir.',
				file=sys.stderr)
		
		relativesrc = abssrc[len(self.rootpath):]
		if relativesrc.startswith(os.sep):
			relativesrc = relativesrc[len(os.sep):]

		head, tail = os.path.split(relativesrc)
		while head:
			head, tail = os.path.split(head)

		result = os.path.join(self.rootpath, tail)

		try:
			pass
			# self.create_link(result)
		except Exception as e:
			print('Failed to recreate symlink: %s'
				% (str(e)),
				file=sys.stderr)

	def create_link(self, target):
		dest = os.path.join(self.symlinkdir, self.path_leaf(target))

		self.delete_link(target)
		os.symlink(os.path.abspath(target), os.path.abspath(dest))

	def delete_link(self, target):
		link = os.path.join(self.symlinkdir, self.path_leaf(target))
		if os.path.lexists(link) == False:
			return

		if os.path.islink(link) == False:
			raise Exception("""Unable to delete existing \
target because it's not a symlink""")

		os.unlink(link)

	def path_leaf(self, path):
		head, tail = os.path.split(path)
		return tail or os.path.basename(head)

	def log(self, msg):
		if self.quiet == False:
			print(msg)

def main():
	"""Parse and check the command line arguments."""
	parser = argparse.ArgumentParser(
	    description="""\
Symlink all files and folders in rootpath into
destpath and watch for any adds/deletes
to keep symlinks consistent.""",
		formatter_class=argparse.RawDescriptionHelpFormatter)

	parser.add_argument('rootpath', type=str,
		help='The directory with the contents you want to symlink.')
	parser.add_argument('destpath', type=str,
		help='The directory where you want the symlinks to be placed')
	parser.add_argument('-q', '--quiet', action='store_true',
		dest='quiet', help='Only print warnings and errors.')
	parser.add_argument('-m', '--monitor', action='store_true',
		dest='monitor', help="""Monitor for changes in rootpath \
and automatically sync changes to the destpath.""")
	args = parser.parse_args()

	if not os.path.isdir(args.destpath):
		print('%s is not a directory.' % args.destpath, file=sys.stderr)
		sys.exit(1)

	if not os.path.isdir(args.rootpath):
		print('%s is not a directory.' % args.rootpath, file=sys.stderr)
		sys.exit(1)

	args.destpath = os.path.normpath(os.path.abspath(args.destpath))
	args.rootpath = os.path.normpath(os.path.abspath(args.rootpath))

	event_handler = SymlinkHandler(args.rootpath, args.destpath, args.quiet)

	if args.monitor:
		observer = Observer()
		observer.schedule(event_handler, args.rootpath, recursive=True)
		observer.start()
		try:
			while True:
				time.sleep(1)
		except KeyboardInterrupt:
			observer.stop()
		observer.join()
		print('Stopped monitoring.')

if __name__ == '__main__':
	main()
