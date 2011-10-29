require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do

    # validating nil types
    project = Project.new
    project.name = nil
    project.description = nil
    result = ! project.valid?
    assert result,"allowing nil values"

    # validating nil type for description
    project = Project.new
    project.name = "new project"
    project.description = nil
    result =  project.valid?
    assert result , "not allowing nil description"

    # validating with proper values
    project = Project.new
    project.name = "itx_test"
    project.description = "some description"
    result =  project.valid?
    project.save
    assert result , "not saving proper values"

    # validating duplicate project name
    project = Project.new
    project.name = "itx_test"
    project.description = "some description"
    result =  !project.valid?
    assert result , "allowing duplicate project name"

  end


end
