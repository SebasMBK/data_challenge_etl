"""
This blocklist is for storing the access tokens from the users that have logged out.
Every access token that belongs to this lists, will be blocked from the Flask App and no longer we
will be able to use it.

Use something like redis in prod, because this will not persist when we restart o recreate the app.
"""

BLOCKLIST = set()