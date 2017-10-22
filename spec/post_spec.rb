require_relative 'spec_helper.rb'

describe 'Tests Praise library' do
  VCR.configure do |c|
    c.cassette_library_dir = './spec/fixtures/cassettes'
    c.hook_into :webmock
  end

  describe 'Pody Information' do
    before do
      VCR.insert_cassette CASSTTE_FILE, record: :new_episodes, match_requests_on: [:method, :uri, :headers]
      @posts = PostsPraise::FacebookAPI.new(CONFIG).get_posts(PAGE_NAME)
    end

    after do
      VCR.eject_cassette
    end

    it 'HAPPY: should be a array' do
      @posts.must_be_instance_of Array
    end

    it 'HAPPY: should provide same post length' do
      _(@posts.size).must_equal CORRECT.size
    end

    it 'HAPPY: should be posts in array' do
      @posts.each do |post|
        post.must_be_instance_of PostsPraise::Post
      end
    end

    it 'HAPPY: should provide same post message' do
      @posts.zip(CORRECT).each do |m1, m2|
        _(m1.message).wont_be_nil
        _(m1.message).must_equal m2.message
      end
    end

    it 'HAPPY: should provide same post id' do
      @posts.zip(CORRECT).each do |m1, m2|

        _(m1.id).wont_be_nil
        _(m1.id).must_equal m2.id
      end
    end
  end
end
