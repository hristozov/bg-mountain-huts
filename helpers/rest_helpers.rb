class RestHelpers
  def self.add
    helpers do
      def get_rest_url(endpoint)
        # XXX: broken with other url params
        return "/rest/#{endpoint}?nonce=#{get_nonce}"
      end
    end
  end
end