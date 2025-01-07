class Search
    include HTTParty
    base_uri 'https://www.googleapis.com/youtube/v3'
  
    def initialize(api_key)
      @api_key = api_key
    end
  
    def search(query, page_token = nil)
      options = {
        query: {
          part: 'snippet',
          q: query,
          maxResults: 30,
          key: @api_key,
          pageToken: page_token
        }
      }
      self.class.get('/search', options)
    end
  end