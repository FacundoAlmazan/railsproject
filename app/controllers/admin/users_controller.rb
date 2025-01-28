class Admin::UsersController < Admin::DashboardController
    before_action :set_user, only: [:show, :destroy, :deactivate]
  
    def index
      @users = User.all
    end
  
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: "Usuario creado exitosamente."
      else
        flash.now[:alert] = @user.errors.full_messages.join(", ")
        render :new, status: :unprocessable_entity
      end
    end
  
    def show; end

    def destroy; end
  
    def deactivate
      if @user.deactivate!
        redirect_to admin_users_path, notice: "Usuario desactivado correctamente."
      else
        redirect_to admin_users_path, alert: "No se pudo desactivar el usuario."
      end
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(:username, :email, :phone, :password, :password_confirmation, :role)
    end
  end
  