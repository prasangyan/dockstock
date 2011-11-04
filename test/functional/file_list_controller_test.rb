require "test_helper"

class FileListControllerTest < ActionController::TestCase
  setup do
  end
  test "should get index" do
    # testing without log in
    get :index
    assert_redirected_to :controller => "dashboard"
    # testing by passing project name as id
    # aasume that there an folder available called 'cimb'
    # creating a project with name 'cimb'

    Project.find_all_by_name('cimb').each do |project|
      project.destroy
    end

    client = Client.new
    client.name = "TestClient23"
    client.description = ""
    if client.save
      project = Project.new
      project.name = "cimb"
      project.client = client
      project.client_id = client.id
      project.save
      get :index, :id => "cimb"
      #assert_redirected_to :controller => "dashboard"
      assert_response :success
    end
      #assert_redirected_to :controller => "authentications", :action => "new"
  end

  test "should get upload" do
    get :upload
    #assert_redirected_to :controller => "authentications", :action => "new"
    assert_response :success
  end
end