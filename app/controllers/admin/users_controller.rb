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
    # Verificar si un gerente intenta asignar el rol admin
    if current_user.manager? && params[:user][:role] == 'admin'
      raise CanCan::AccessDenied.new
    end
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
      raise CanCan::AccessDenied.new
    end
    # Verificar si el usuario actual está intentando cambiar su propio rol
    if current_user == @user && params[:user][:role] != @user.role
      raise CanCan::AccessDenied.new
    end
    if @user.update(user_params)
      if request.referer&.include?(edit_admin_user_path(current_user))
        redirect_to admin_root_path, notice: "Tu perfil se ha actualizado correctamente."
      else
        redirect_to admin_users_path, notice: "Usuario actualizado exitosamente."
      end
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
  
    if can?(:update, @user) && current_user != @user
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
