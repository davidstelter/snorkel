# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_snorkel_session',
  :secret      => '4bfd87b430f3976b57a0e75a908dcc7b8f1910e0b978d796d2cb78e15f14c1c1f77e33e874f5e848d7506fe2747159b52c731d94f076aeda2233b032a2aa51b3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
