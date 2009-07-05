# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_media_lender_session',
  :secret      => '27faa9c9aa6118512e14ef081cdda76fed340a4eaa45a868c001e965c286861b7b05d1e2ea53e2c2012a05f7226b557bac7cc8200bc8d950c3881b9dcdab31b2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
