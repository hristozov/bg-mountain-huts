class CookieHelpers
  def self.add
    helpers do
      def get_cookie
        content = rand(32 ** 30).to_s(32)[0..30]
        cookie = Cookie.create({data: content, date: Time.new()})
        content
      end

      def remove_cookie(data)
        Cookie.delete_all({data: data})
      end

      def check_cookie(data)
        return false unless data and data.length > 0
        result = Cookie.where({data: data})
        return result.count > 0
      end
    end
  end
end