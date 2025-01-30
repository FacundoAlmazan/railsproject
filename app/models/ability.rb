class Ability
  include CanCan::Ability

  def initialize(user)
    # Asegúrate de que siempre haya un usuario autenticado
    return unless user

    if user.admin?
      # Los administradores tienen acceso completo a todas las funcionalidades
      can :manage, :all 
    elsif user.manager?
      # Los gerentes tienen acceso a la gestión de productos y ventas
      can :manage, Sale
      can :manage, Product
      can :manage, ProductVariant
    
      # Los gerentes pueden gestionar usuarios pero solo crear y editar roles manager y employee
      can :read, User
      can :create, User, role: ['manager', 'employee']
      
      # Permitir actualizar usuarios con rol manager o employee
      can :update, User, role: ['manager', 'employee']
      
      # Bloquear cualquier intento de asignar el rol admin en la actualización
      can :update, User do |u|
        u.role != 'admin' # Evita que se le asigne el rol admin
      end
    
      cannot :update, User, role: 'admin' # No pueden modificar usuarios que ya sean admin
      cannot :create, User, role: 'admin' # No pueden crear admins
      
    elsif user.employee?
      # Los empleados tienen acceso de lectura a productos y ventas
      can :manage, Sale
      can :manage, Product
      can :manage, ProductVariant
    end

    # Todos los usuarios autenticados pueden actualizar su propia cuenta
    can [:update], User, id: user.id
  end
end
