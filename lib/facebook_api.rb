require 'http'
require_relative 'posts_data.rb'

module PostsPraise
  # Library for FacebookAPI
  class FacebookAPI
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(config)
      @fb_token = config['FB_API_TOKEN']
    end

    def getPosts(fanpageName)
      fanpage_id_info = get_fanpage_id(fanpageName)
      cowbeiNTHU_post_url = fb_get_Fanpage_posts_path(fanpage_id_info['id'], 'fields=message&limit=100')
      fanPages_Posts = JSON.parse(call_fb_api_url(cowbeiNTHU_post_url))
      fanPages_Posts['data'].each do |post|
        Post.new(post)
      end
    end

    def get_fanpage_id(fanpage)
      cowbeiNTHU_id_url = fb_get_id_path(fanpage)
      JSON.parse(call_fb_api_url(cowbeiNTHU_id_url))
    end

    def fb_get_id_path(id)
      puts 'https://graph.facebook.com/v2.10/' + id
      'https://graph.facebook.com/v2.10/' + id
    end

    def call_fb_api_url(url)
      HTTP.headers(
        'Authorization' => "Bearer #{@fb_token}"
      ).get(url)
    end

    def fb_get_Fanpage_posts_path(id, fields = '')
      puts 'https://graph.facebook.com/v2.10/' + id + '/feed?' + fields
      'https://graph.facebook.com/v2.10/' + id + '/feed?' + fields
    end

    def successful?(result)
      HTTP_ERROR.keys.include?(result.code) ? false : true
    end

    def raise_error(result)
      raise(HTTP_ERROR[result.code])
    end
  end
end
