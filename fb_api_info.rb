require 'http'
require 'yaml'
require 'json'
require_relative './lib/facebook_api.rb'

fb_response = {}
fb_results = {}

config = YAML::load(File.read('./config/secrets.yml'))
#https://graph.facebook.com/v2.10/576472312465910_1462879673825165?fields=id,likes{name,link},message,expanded_height,created_time,with_tags&access_token=132884690698758|dQjGqLbXdJtjOeX8tB55nVHLfSw

fbapiclient = PostsPraise::FacebookAPI.new(config)
cowbeiNTHU_id_url = fbapiclient.get_fanpage_id('cowbeiNTHU')

fb_response[cowbeiNTHU_id_url] = fbapiclient.call_fb_api_url(cowbeiNTHU_id_url)
fanpages = JSON.parse(fb_response[cowbeiNTHU_id_url])
fb_results[cowbeiNTHU_id_url] = fanpages

cowbeiNTHU_post_url = fbapiclient.fb_get_Fanpage_posts_path(fanpages['id'], 'fields=message&limit=100')
fanPages_Posts = JSON.parse(fbapiclient.call_fb_api_url(cowbeiNTHU_post_url))
fb_results[cowbeiNTHU_post_url] = fanPages_Posts

File.write('./spec/fixtures/results.yml', fb_results.to_yaml)
