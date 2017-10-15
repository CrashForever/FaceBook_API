require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/facebook_api.rb'

describe 'Tests Praise library' do
    PAGE_NAME = 'cowbeiNTHU'.freeze
    CONFIG = YAML.safe_load(File.read('../config/secrets.yml'))
    CORRECT = YAML.load(File.read('fixtures/results.yml'))

    describe 'Pody Information' do
        before do
            @posts = PostsPraise::FacebookAPI.new(CONFIG)
                                             .getPosts(PAGE_NAME)
        end

        it "HAPPY: should be a array" do
            @posts.must_be_instance_of Array
        end

        it 'HAPPY: should provide same post length' do
            _(@posts.size).must_equal CORRECT.size
        end

        it "HAPPY: should be posts in array" do
            @posts.each do |post|
                post.must_be_instance_of PostsPraise::Post
            end
        end

        it 'HAPPY: should provide same post message' do
            @posts.zip(CORRECT).each do |m1, m2|
                m1.message.must_equal m2.message
            end
        end

        it 'HAPPY: should provide same post id' do
            @posts.zip(CORRECT).each do |m1, m2|
                m1.id.must_equal m2.id
            end
        end
    end
end
