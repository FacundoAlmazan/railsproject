class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enum para roles
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
  
end
