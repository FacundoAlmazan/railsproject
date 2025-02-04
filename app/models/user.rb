class User < ApplicationRecord
  # Scope para usuarios activos
  scope :active, -> { where(deactivated_at: nil) }

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #(por algún motivo los enum me tiran error...)
  #enum role: { admin: "admin", manager: "manager", employee: "employee" }

  # Validación
  #validates :role, presence: true

  ROLES = %w[admin manager employee].freeze

  validates :password, presence: true, if: :password_required?
  validates :username, presence: true, length: {minimum: 6, maximum: 20}, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone, length: {minimum: 8, maximum: 15}, presence: true
  validates :role, presence: true, inclusion: { in: ROLES }

  def admin?
    role == "admin"
  end

  def manager?
    role == "manager"
  end

  def employee?
    role == "employee"
  end
  
  def deactivate!
    update(deactivated_at: Time.current, password: SecureRandom.hex)
  end

  def active?
    deactivated_at.nil?
  end
  
  def password_required?
    # La contraseña es requerida si:
    # - Es un nuevo registro (new_record?)
    # - O el campo de password está presente (para cambios de contraseña)
    new_record? || password.present?
  end

end
