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

  FlickRaw.api_key        = CONFIG['auth']['api_key']
  FlickRaw.shared_secret  = CONFIG['auth']['consumer_secret']

  list   = flickr.photos.getRecent
  
  list.each do |image|
    secret  = image.secret
    id      = image.id
    info    = flickr.photos.getInfo :photo_id => id, :secret => secret
    puts image.id
    puts info.title
    puts info.dates.taken 
  end
  