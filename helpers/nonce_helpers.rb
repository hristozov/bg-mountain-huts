class NonceHelpers
  def self.add
    helpers do
      def get_nonce
        token = rand(32 ** 30).to_s(32)[0..30]
        Nonce.create({token: token, date: Time.now()})
        token
      end

      def nonce_valid?(token)
        # XXX: bypass
        return true
        return false unless token and token.length > 0
        result = Nonce.where({token: token})
        return false unless result.count > 0
        diff = Time.now() - result[0].date.to_time
        return diff < 3600
      end
    end
  end
end