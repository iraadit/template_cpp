GNU/Linux AppImage
==================

AppImage is a portable format for upstream software distribution for GNU/Linux
systems, the only constraint is that a single AppImage must target a single
hardware architecture, such as ``x86_64``.

Refer to the upstream AppImage website for details: https://appimage.org/.

Cross-compiling
---------------

The ``appimage_x86_64`` job makes an assumption that the host of this container
itself is a ``x86_64`` machine. Cross-compiling is possible with AppImage,
albeit somewhat complicated.

The ``AppRun`` and ``runtime`` used must match the target architecture. The
``appimagetool`` itself can be used from the host's native architecture. Refer
to https://github.com/AppImage/AppImageKit/issues/789 for more information.
Pre-built ``AppRun`` and ``runtime`` are provided by the project for the
``i686`` and ``x86_64`` architectures, but for all others you will need to build
these two files yourself. This is typically done inside ``bootstrap.sh`` for the
Docker image targeting a specific architecture.

The actual build script for an AppImage remains the same across architectures,
since the compiler prefix can be a variable, special YAML features can be used
to simplify the CICD YAML. See
https://docs.gitlab.com/ee/ci/yaml/#special-yaml-features.
