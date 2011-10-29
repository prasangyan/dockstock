class Document < ActiveRecord::Base
    belongs_to :project
    belongs_to :category
    belongs_to :authentication

    has_many :comments
    has_many :histories

    validates_presence_of :name, :project_id, :category_id, :authentication_id
    validates_uniqueness_of :name

  def addhistory_new(currentuserid)
    history = define_history(currentuserid)
    history.description = "Uploaded a new document."
    unless history.save
      puts history.errors.full_messages
    end
  end

  def addhistory_version(currentuserid)
    history = define_history(currentuserid)
    history.description = "Uploaded a new version."
    history.save
  end

  private
  def define_history(currentuserid)
    history = History.new
    history.document_id = self.id
    history.authentication_id = currentuserid
    history.authentication = Authentication.find(:first, :conditions => "id = #{currentuserid}")
    history
  end

end
