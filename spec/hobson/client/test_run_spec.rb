require 'spec_helper'

describe Hobson::Client::TestRun do

  subject{ Hobson::Client::TestRun }

  it { subject.attributes.should == Set[:id, :path, :project_origin, :sha, :requestor, :created_at] }

  describe ".resource_name" do
    it "should be :test_run" do
      Hobson::Client::TestRun.resource_name.should == :test_run
    end
  end

  describe ".get" do

    let(:rest_client_stub){ Object.new }
    let(:nested_rest_client_stub){ Object.new }
    let(:server_response){
      {
        "test_run" => {
          'id'              => "42",
          'path'            => "/test_runs/42",
          'project_origin'  => "git@github.com/test/thing",
          'sha'             => "60438595a1b6a2c2a188aabf79a45f64f6de7a04",
          'requestor'       => "Jared Grippe",
          'created_at'      => "2012-09-18 05:18:50 -0700",
          'jobs' => [
            {}
          ],
          'tests' => [
            {}
          ],
        }
      }
    }

    before do
      subject.should_receive(:resource).and_return{ rest_client_stub }
      rest_client_stub.should_receive(:[]).with(42).and_return{ nested_rest_client_stub }
      nested_rest_client_stub.should_receive(:get).and_return{ server_response.to_json }
    end

    it "should work" do
       test_run = Hobson::Client::TestRun.get(42)
       test_run.id.should == "42"
       test_run.path.should == "/test_runs/42"
       test_run.project_origin.should == "git@github.com/test/thing"
       test_run.sha.should == "60438595a1b6a2c2a188aabf79a45f64f6de7a04"
       test_run.requestor.should == "Jared Grippe"
       test_run.created_at.should == "2012-09-18 05:18:50 -0700"

       test_run.jobs.first.class.should == Hobson::Client::TestRun::Job
       test_run.tests.first.class.should == Hobson::Client::TestRun::Test
    end

  end

end
