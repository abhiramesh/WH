class UsersController < ApplicationController
  before_filter :authorize, :only => [:index, :edit, :new]
  before_filter :signed_in, :only => [:create_search, :show_results, :view_classes]

  # GET /users
  # GET /users.json

  def facebook
    omniauth = request.env["omniauth.auth"]
    if omniauth
      omniauth['extra']['raw_info']['email'] ? email =  omniauth['extra']['raw_info']['email'] : email = ''
      omniauth['extra']['raw_info']['name'] ? name =  omniauth['extra']['raw_info']['name'] : name = ''
      omniauth['extra']['raw_info']['id'] ?  uid =  omniauth['extra']['raw_info']['id'] : uid = ''
      omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
      omniauth['credentials']['token'] ? oauth_token =  omniauth['credentials']['token'] : oauth_token = ''
      omniauth['credentials']['expires_at'] ? oauth_expires_at =  Time.at(omniauth['credentials']['expires_at']) : oauth_expires_at = ''

      if !user_signed_in?
        user = User.find_by_uid(uid)
        if user
          sign_in_and_redirect(:user, user)
        else
          if email != ''
            user = User.create(email: email, name: name, provider: provider, uid: uid, oauth_token: oauth_token, oauth_expires_at: oauth_expires_at, password: SecureRandom.hex(10))
          end
          sign_in_and_redirect(:user, user)
        end
      else
        redirect_to user_path(current_user)
      end
    end
  end

  def create_search
    if params["search"] != ""
      if Result.find_by_query(params["search"]) == nil
        current_user.find_classmates(params["search"])
        redirect_to '/results/' + params["search"]
      else
        redirect_to '/results/' + params["search"]
      end
    else
      redirect_to :back
    end
  end

  def show_results
    @results = Result.where(:query => params[:id], :user_id => current_user.id)
  end

  def view_classes
    @results = current_user.results
    @classes = []
    @results.each do |r|
      @classes << r.query
    end
    @classes = @classes.uniq!
  end

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    if current_user.id != @user.id
      redirect_to root_path
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
