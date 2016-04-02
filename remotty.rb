require 'uri'
require 'net/http'

class Remotty
  def initialize
    @uri = URI.parse(ENV['REMOTTY_HOOK_URI'])
  end

  def post_message!(message)
    Net::HTTP.post_form(@uri, {'message' => message})
  end
end
