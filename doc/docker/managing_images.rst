Managing docker images
======================

.. note:: Requires an UNIX environment.

Helper script
-------------

For managing docker images which are described inside the repository a helper
script exists for building and pushing those images to arbitrary locations.

The script itself is located in ``/ci/docker/image.sh``. You may want to read
its ``--help`` before continuing.

.. code-block:: console

	./ci/docker/image.sh --help

Docker targets
--------------

As mentioned, docker targets go into ``../docker_targets`` from the perspective
of the script. In the repo that would be ``/ci/docker_targets``.

All directories in this directory are seen as docker targets. Each directory
should contain a standard ``Dockerfile`` and a non-standard ``Tagfile``. The
``Tagfile`` is a one-liner containing the tag to be used for this image.

General advice
--------------

A few tips that may prove to be useful when managing images.

Version management
~~~~~~~~~~~~~~~~~~

.. note::
	When two branches would need to edit the exact same docker image they
	will overwrite each other on push. This is a limitation of the way
	docker images are managed with this "version control". For most use
	cases this method should be fine however, as depedencies usually do not
	change a lot later in a project's lifetime.

When changing a docker image, you are advised to version bump the ``Tagfile``.
This way you don't overwrite the existing image and avoid breaking everything
for all branches depending on the image.

In your own branch edit the files for the image and when you are satisfied
build and push the new image with the helper script. You can either commit
before or after doing this. I usually do it after, in case building the image
fails. Though you could also use ``git commit --amend``.

Keep in mind to push the image **before** pushing the commit, or CI will fail
because the new version does not exist yet in the registry.

Using a different repository for images
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You could also use a different repository for managing the images and let that
repository's CI build and push images to "this" repository's registry. I found
that would be overcomplicated for relatively simple images running CI, but it
may prove useful to some more complicated setups where images are also shared
across various projects.
