class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: %i[show edit update destroy ]
  
    # GET /users or /users.json
    def index
      @user = current_user
      @search = User.ransack(params[:q])
      @users = @search.result(distinct: true).order(created_at: :desc).page(params[:page])
    end
  
    # GET /users/1 or /users/1.json
    def show
    end
  
  
    # GET /users/new
    def new
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
  
      respond_to do |format|
        if @user.save
          sign_in(current_user, bypass: true)
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
      def set_user
        @user = User.find(params[:id])
      end
  
      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone, :role_mask, :avatar)
      end
end
  