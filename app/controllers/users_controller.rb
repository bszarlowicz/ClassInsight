class UsersController < ApplicationController
  load_and_authorize_resource
    
  
    # GET /users or /users.json
    def index
      @search_url = users_path
      @user = current_user
      @title = User.model_name.human(count: 2)
      @search = User.ransack(params[:q])
      @users = @search.result(distinct: true).order(created_at: :desc).page(params[:page])
    end
  
    # GET /users/1 or /users/1.json
    def show
    end
  
  
    # GET /users/new
    def new
      @user = User.new
    end
  
    # GET /users/1/edit
    def edit
      @resource = @user
      @resource_name = :user
      @devise_mapping = Devise.mappings[:user]
    end
  
    # POST /users or /users.json
    def create
      @user = User.new(user_params)

      password = Devise.friendly_token[0, 20]
      @user.password = password
      @user.password_confirmation = password
      @user.type = "Student"

      respond_to do |format|
        if @user.save
          @user.update(temporary_password: password)
          # sign_in(current_user, bypass: true)
          format.html { redirect_to users_path, notice: flash_message(:create, User) }
        else
          format.html {
            render :new
          }
        end
      end
    end

    # PATCH/PUT /users/1 or /users/1.json
    def update
      self_update = current_user == @user
      @username = user_params[:name]
      respond_to do |format|
        if user_params[:password].present? ? @user.update(user_params) : @user.update_without_password(user_params)
          sign_in(@user, bypass: true) if self_update
          flash[:notice] = "Użytkownik został zaktualizowany."
          format.turbo_stream
          flash.discard
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @user.destroy
      redirect_to users_url, notice: 'User was successfully destroyed.'
    end
  
    private
      def user_params
        params.require(:user).permit(User.permitted_params)
      end
end
  