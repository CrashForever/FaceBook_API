require 'http'
require 'vcr'
require 'webmock'
require_relative 'posts_data.rb'

module PostsPraise
  # Library for FacebookAPI
  class FacebookAPI
    module Errors
      # Not allowed to access resource
      Unauthorized = Class.new(StandardError)
      # Requested resource not found
      NotFound = Class.new(StandardError)
    end
    # Encapsulates API response success and errors
    class Response
      HTTP_ERROR = {
        # Not allowed to access resource
        401 => Errors::Unauthorized,
        404 => Errors::NotFound
      }.freeze

      def initialize(response)
        @response = response
      end

      def successful?
        HTTP_ERROR.keys.include?(@response.code) ? false : true
      end

      def response_or_error
        successful? ? @response : raise(HTTP_ERROR[@response.code])
      end
    end

    def initialize(config)
      @fb_token = config['FB_API_TOKEN']
    end

    def get_posts(fanpage_name)
      posts = []
      fanpage_id_info = get_fanpage_id(fanpage_name)
      cowbeinthu_post_url = FacebookAPI.fb_get_fanpage_posts_path(fanpage_id_info['id'], 'fields=message&limit=100')

      VCR.configure do |config|
        config.cassette_library_dir = '../spec/fixtures/cassettes/'
        config.hook_into :webmock
        config.filter_sensitive_data('<FACEBOOK_TOKEN>') { @fb_token }
        config.filter_sensitive_data('<FACEBOOK_TOKEN_ESC>') { CGI.escape(@fb_token) }
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
      cowbeinthu_id_url = FacebookAPI.fb_get_id_path(fanpage)
      JSON.parse(call_fb_api_url(cowbeinthu_id_url))
    end

    def self.fb_get_id_path(id)
      'https://graph.facebook.com/v2.10/' + id
    end

    def call_fb_api_url(url)
      HTTP.headers(
        'Authorization' => "Bearer #{@fb_token}"
      ).get(url)
    end

    def self.fb_get_fanpage_posts_path(id, fields = '')
      'https://graph.facebook.com/v2.10/' + id + '/feed?' + fields
    end
  end
end
