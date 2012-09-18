class Hobson::Client::TestRun::Test < Hobson::Client::Resource

  resource_name :test

  attributes :id, :path, :project_origin, :sha, :requestor, :created_at

end
