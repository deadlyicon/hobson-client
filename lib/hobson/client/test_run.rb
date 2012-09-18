class Hobson::Client::TestRun < Hobson::Client::Resource

  self.resource_name = :test_run

  attributes :id, :path, :project_origin, :sha, :requestor, :created_at

  nested_resource :tests, :class => :'Hobson::Client::TestRun::Test'
  nested_resource :jobs,  :class => :'Hobson::Client::TestRun::Job'

end

require "hobson/client/test_run/test"
require "hobson/client/test_run/job"
