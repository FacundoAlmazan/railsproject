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
  
end
