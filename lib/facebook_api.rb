require 'http'
require 'vcr'
require 'webmock'
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

    def get_posts(fanpage_name)
      posts = []
      fanpage_id_info = get_fanpage_id(fanpage_name)
      cowbeinthu_post_url = fb_get_fanpage_posts_path(fanpage_id_info['id'], 'fields=message&limit=100')

      VCR.configure do |c|
        c.cassette_library_dir = '../spec/fixtures/cassettes/'
        c.hook_into :webmock
        c.filter_sensitive_data('<FACEBOOK_TOKEN>') { @fb_token }
        c.filter_sensitive_data('<FACEBOOK_TOKEN_ESC>') { CGI.escape(@fb_token) }
      end
      VCR.insert_cassette 'fbAPI', record: :new_episodes

      fanpages_posts = JSON.parse(call_fb_api_url(cowbeinthu_post_url))
      VCR.eject_cassette

      fanpages_posts['data'].each do |post|
        posts.push(Post.new(post))
      end
      posts
    end

    private

    def get_fanpage_id(fanpage)
      cowbeinthu_id_url = fb_get_id_path(fanpage)
      JSON.parse(call_fb_api_url(cowbeinthu_id_url))
    end

    def fb_get_id_path(id)
      'https://graph.facebook.com/v2.10/' + id
    end

    def call_fb_api_url(url)
      HTTP.headers(
        'Authorization' => "Bearer #{@fb_token}"
      ).get(url)
    end

    def fb_get_fanpage_posts_path(id, fields = '')
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
