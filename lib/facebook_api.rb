require 'http'

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

    def get_fanpage_id(fanpage)
      fb_get_id_path(fanpage)
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
  end
end
