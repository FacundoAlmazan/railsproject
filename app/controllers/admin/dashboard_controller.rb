class Admin::DashboardController < ApplicationController
    before_action :authenticate_user! # Protege todas las rutas de administración con autenticación
    before_action :authorize_admin    # Valida el rol del usuario
  
    layout "admin" # Especifica que se usará el layout admin
  
    private
  
    def authorize_admin
      unless current_user&.role.in?(%w[employee manager admin])
        redirect_to root_path, alert: 'No tienes permiso para acceder a esta sección.'
      end
    end
  end