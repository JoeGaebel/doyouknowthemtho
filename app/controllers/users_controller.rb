class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, only: [:index]
  ADMIN_DIGEST = '$2a$10$7.P8UgKQcVcEi6xBIHCFtuk7.PfPKlvCKhRZvh/7z8MhJOvbLuEbe'

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def index
    @users = User.all
  end

  def show
    @url_name = @user.mistaken_name.downcase.sub(' ', '')
  end

  def challenge
    query = <<-SQL
      SELECT *
      FROM USERS
      where lower(REPLACE(mistaken_name, ' ', ''))
      LIKE lower(?)
      LIMIT 1
    SQL

    if (user = User.find_by_sql([query, params[:mistaken_name]])).present?
      @user = user.first
      @page_title = @user.mistaken_name
    else
      not_found
    end
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end


    def user_params
      not_allowed = /[@$%\\\/<>()0-9][^A-Za-z\s]/
      params["user"]["preferred_name"].gsub!(not_allowed, '')
      params["user"]["mistaken_name"].gsub!(not_allowed, '')
      params.require(:user).permit(:preferred_name, :mistaken_name, :avatar)
    end

    def authenticate
      authenticate_or_request_with_http_basic('Administration') do |username, password|
        username == 'admin' && PasswordDigester.check?(password, ADMIN_DIGEST)
      end
    end
end
