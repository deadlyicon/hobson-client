class Hobson::Client::TestRun < Hobson::Client::Resource

  @name = :test_run

  nested_resource :tests, :class => :'Hobson::Client::TestRun::Test'
  nested_resource :jobs,  :class => :'Hobson::Client::TestRun::Job'

end

require "hobson/client/test_run/test"
require "hobson/client/test_run/job"
