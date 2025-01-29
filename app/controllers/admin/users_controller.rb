class Admin::UsersController < Admin::DashboardController
  load_and_authorize_resource
  before_action :set_user, only: [:edit, :update, :deactivate]

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

  def edit; end

  def update
    # Verificar si el usuario actual está intentando cambiar el rol a admin sin permiso
    if current_user.manager? && params[:user][:role] == 'admin'
      raise CanCan::AccessDenied.new("No tienes permiso para asignar el rol admin.", :update, User)
    end
  
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "Usuario actualizado exitosamente."
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def deactivate
    @user.deactivate!
    redirect_to admin_users_path, notice: "Usuario desactivado exitosamente."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    permitted = [:username, :email, :phone, :password, :password_confirmation]
  
    if can?(:update, User) && current_user != @user
      if current_user.manager?
        # Los gerentes pueden editar usuarios, pero no asignar el rol "admin"
        permitted << :role unless params[:user][:role] == 'admin'
      else
        # Los administradores pueden cambiar cualquier rol
        permitted << :role
      end
    end
  
    params.require(:user).permit(permitted)
  end
end
