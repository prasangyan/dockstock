require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  setup do
    @project = projects(:one)
  end

  test "should get index" do
    get :index
    assert_redirected_to :controller => "clients"

    get :index , :id => "MyString"
    assert_response :success

    #assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new   , :id => "MyString"
    assert_response :success
    #   #assert_not_nil(@project)
  end

  test "should create project" do
      # with valid project name
      Project.all.each do |project|
        project.destroy
      end

      Client.all.each do |client|
        client.destroy
      end

      client = Client.new
      client.name = "some test client"
      client.description = "some description"
      client.save

      post :create, :name => projects(:one)[:name], :description => projects(:one)[:description], :client_id => Client.find(:first).id
      assert_redirected_to "/projectlist/some test client"
      #assert_equal(flash[:notice], "Project was successfully created.")

      # with nil values
      post :create, :name => nil, :description => nil, :client_id => Client.find(:first).id
      assert_redirected_to :controller => "clients"
      #assert_not_equal(flash[:notice], "Project was successfully created.")

      #with duplicate project name
      post :create, :name => nil, :description => nil, :client_id => Client.find(:first).id
      assert_redirected_to :controller => "clients"
      #assert_not_equal(flash[:notice],"Project was successfully created.")
  end

end
