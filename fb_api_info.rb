require 'http'
require 'yaml'
require 'json'
require_relative './lib/facebook_api.rb'

config = YAML::load(File.read('./config/secrets.yml'))
#https://graph.facebook.com/v2.10/576472312465910_1462879673825165?fields=id,likes{name,link},message,expanded_height,created_time,with_tags&access_token=132884690698758|dQjGqLbXdJtjOeX8tB55nVHLfSw

fbapiclient = PostsPraise::FacebookAPI.new(config)
fb_results = fbapiclient.getPosts('cowbeiNTHU')

File.write('./spec/fixtures/results.yml', fb_results.to_yaml)
