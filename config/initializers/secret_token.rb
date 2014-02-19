# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Deployer::Application.config.secret_key_base = '43c55440c8d6c2a3d0443006a8e63581910de3dd56022ac1b27b724d96adc97550f433d0e88ab2844807c0238373eaf137d8c37c25685afd97f200572c540218'
