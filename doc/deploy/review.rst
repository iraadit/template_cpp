Per-branch documentation review
===============================

.. note::

	The templates uses the shared host ``doc.mel.vin`` which is for internal
	use only. You need a webserver with ``rsync`` (secure) or some other
	way to upload and delete things from a CI job like ``ftp`` (insecure).

For every commit pushed to any branch generated documentation is published to a
webserver in the style of ``some.tld/${GROUP}/${PROJECT}``. For the template
itself ``rsync`` is used over SSH as it is most secure.

The advantage of having a deployment per branch is that the reviewer of a merge
request doesn't have to check out locally and build documentation in order to
look at the changes. A link to the online environment is shown on the merge
request page itself.

The deployment environment is dynamically created when a new branch is created
on GitLab. The environment is also dynamically stopped and cleaned up after the
branch has been deleted, usually when the merge request has been accepted.

GitLab has more documentation regarding this:

* https://about.gitlab.com/features/review-apps/
* https://docs.gitlab.com/ee/ci/review_apps/

For ``doc.mel.vin`` I configured a chrooted, ``rsync``-only account with
``rssh`` and pointed the webserver to there. Some more details, primarily
intended for users, is available at https://doc.doc.mel.vin/.
