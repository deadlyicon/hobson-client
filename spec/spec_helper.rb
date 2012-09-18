ROOT = Pathname.new File.expand_path('../..', __FILE__)
LIB  = ROOT + 'lib'

require 'hobson/client'

Hobson::Client.config = {:server => 'http://example.com'}

Dir[ROOT.join('spec/support/**/*.rb')].each{ |support| require support }

RSpec.configure do |config|

  config.before do

  end

end
