class Search
    include HTTParty
    base_uri 'https://www.googleapis.com/youtube/v3'
  
    def initialize(api_key)
      @api_key = api_key
    end
  
    def search(query, max_results = 100)
      options = {
        query: {
          part: 'snippet',
          q: query,
          maxResults: max_results,
          key: @api_key
        }
      }
      self.class.get('/search', options)
    end
  end