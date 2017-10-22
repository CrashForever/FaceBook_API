module PostsPraise
  # Data Structure for Post
  class Post
    def initialize(data)
      @data = data
    end

    def message
      @data['message']
    end

    def id
      @data['id']
    end
  end
end
