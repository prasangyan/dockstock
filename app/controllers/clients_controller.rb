class ClientsController < ApplicationController
    before_filter :isuserloggedin
  # GET /clients
  # GET /clients.xml
  def index
    @clients = Client.all
  end

  # GET /clients/new
  # GET /clients/new.xml
  def new
    @client = Client.new
    #render :layout => "authentications"
    render :layout => false
  end

  # POST /clients
  # POST /clients.xml
  def create
    @client = Client.new(params[:client])
    if @client.save
      #puts "created a client"
      flash[:notice] = 'Client was successfully created.'
    else
      #puts @client.errors
      flash[:notice] = 'Unable to create a client.'
    end
    @clients = Client.all
    render :index
  end

end
