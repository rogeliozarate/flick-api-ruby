require 'flickraw'
require 'yaml'

CONFIG_FILE = "config.yaml"


  if File.exist?(CONFIG_FILE) && File.ftype(CONFIG_FILE) == 'file'
    CONFIG = YAML::load(File.read('config.yaml'))
    puts 'Config file loaded'
    puts '----------------------------------------------------------'
  else
    abort "\n\nFile config.yaml does not exist. Please edit config.example and save it as config.yaml\n\n"
  end
  
  puts "     api key : #{CONFIG['auth']['api_key']}"
  puts "shared secret: #{CONFIG['auth']['consumer_secret']}"
  
  FlickRaw.api_key        = CONFIG['auth']['api_key']
  FlickRaw.shared_secret  = CONFIG['auth']['consumer_secret']

  
  token = flickr.get_request_token
  auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'delete')

  puts "Open this url in your process to complete the authication process : #{auth_url}"
  puts "Copy here the number given when you complete the process."
  `open #{auth_url}`

  verify = gets.strip

  begin
    flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
    login = flickr.test.login
    puts "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
    # Update our config file 
    File.open(CONFIG_FILE, 'w') do |out|
      CONFIG['auth']['access_token']  = flickr.access_token
      CONFIG['auth']['access_secret'] = flickr.access_secret
      YAML::dump(CONFIG, out)
    end
  rescue FlickRaw::FailedResponse => e
    puts "Authentication failed : #{e.msg}"
  end
