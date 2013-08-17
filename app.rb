require 'flickraw'
require 'yaml'


CONFIG_FILE = "config.yaml"


  if File.exist?(CONFIG_FILE) && File.ftype(CONFIG_FILE) == 'file'
    CONFIG = YAML::load(File.read('config.yaml'))
    puts 'config file loaded'
  else
    abort "\n\nFile config.yaml does not exist. Please edit config.example and save it as config.yaml\n\n"
  end
  puts 
  puts 


  FlickRaw.api_key= CONFIG['auth']['api_key']
  FlickRaw.shared_secret=CONFIG['auth']['consumer_secret']

  list   = flickr.photos.getRecent
  list.each do |image|
    puts image.id
    puts image.title
  end