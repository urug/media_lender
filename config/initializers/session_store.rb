# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_media_lender_session',
  :secret      => 'df8f4fe8db97043f61521e82a82e4feed5b98651cff6c085b417036d175d66cc4a6f08242ad83ff4f25c5e20ab321789b3fe2aa130a1fb0c9b94103ba4dec05a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
