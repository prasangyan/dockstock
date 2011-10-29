class CommentsController < ApplicationController
    before_filter :isuserloggedin
  # GET /comments
  # GET /comments.xml
  def index
    id = params[:id]
    @document = Document.find(:first,:conditions =>  "id = #{id}")
    @project_name = @document.project.name
    @client_name = @document.project.client.name
    @comments = Comment.find_all_by_document_id(id)
    @history = @document.histories
    @comment = Comment.new
  end
  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new
    @document = Document.find(:first, :conditions => "id = #{params[:id]}")
    @project_name = @document.project.name
    @client_name = @document.project.client.name
    render :layout => false
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new
    @comment.comment = params[:comment]
    @comment.document_id = params[:document_id]
    #puts "the current user id is " + session[:currentuser].to_s
    @comment.authentication_id = Authentication.find_by_id(session[:currentuser]).id
    if @comment.save
      flash[:notice] = 'Comment was successfully created.'
    else
      flash[:notice] = 'An error occured while saving comment.'
    end
    redirect_to :back
  end
end
