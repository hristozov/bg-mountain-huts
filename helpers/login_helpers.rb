class LoginHelpers
  def self.add
    helpers do
      def require_login
        halt 401 unless check_cookie(cookies[:huts_login])
      end

      def is_logged_in?
        check_cookie(cookies[:huts_login])
      end
    end
  end
end