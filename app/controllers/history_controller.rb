class HistoryController < ApplicationController
                         before_filter :isuserloggedin
  def index

    documentid = params[:id]
    unless documentid.nil?
      @document = Document.find(:first, :conditions => "id = #{documentid}")
      @history = @document.histories
      @project_name =@document.project.name
      @client_name = @document.project.client.name
    else
      @history = nil
      @project_name = ""
      @client_name = ""
    end

  end

end
