require 'http'
require 'yaml'
require 'json'

fb_response = {}
fb_results = {}

config = YAML.safe_load(File.read('./config/secrets.yml'))
#https://graph.facebook.com/v2.10/576472312465910_1462879673825165?fields=id,likes{name,link},message,expanded_height,created_time,with_tags&access_token=132884690698758|dQjGqLbXdJtjOeX8tB55nVHLfSw
def fb_get_id_path(id)
  puts 'https://graph.facebook.com/v2.10/'+id
  'https://graph.facebook.com/v2.10/'+id
end

def fb_get_Fanpage_posts_path(id, fields="")
  puts 'https://graph.facebook.com/v2.10/'+id+"/feed?"+fields
  'https://graph.facebook.com/v2.10/'+id+"/feed?"+fields
end

def call_fb_api_url(url, config)
  HTTP.headers(
    'Authorization' => "Bearer #{config['FB_API_TOKEN']}"
  ).get(url)
end

cowbeiNTHU_id_url = fb_get_id_path('cowbeiNTHU')

fb_response[cowbeiNTHU_id_url]=call_fb_api_url(cowbeiNTHU_id_url, config)
fanPages = JSON.parse(fb_response[cowbeiNTHU_id_url])
fb_results[cowbeiNTHU_id_url] = fanPages

cowbeiNTHU_post_url = fb_get_Fanpage_posts_path(fanPages['id'], "fields=message,actions,reactions,comments&limit=100")
fanPages_Posts = JSON.parse(call_fb_api_url(cowbeiNTHU_post_url, config))


fb_results[cowbeiNTHU_post_url] = fanPages_Posts
File.write('./spec/fixtures/results.yml',fb_results.to_yaml)
