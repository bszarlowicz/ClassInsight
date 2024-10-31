class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :name, presence: true
  validates :password, length: {minimum: 8}, format: {with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{8,40}\z/, message: :invalid_password_format}, if: :password_validation?
  validates :phone, phone: true, allow_blank: true
  before_save :normalize_phone

  after_create :auto_set_role

  ROLES = {
    "A" => "admin",
    "T" => "teacher",
    "S" => "student"
  }

  def roles
    return [] unless role_mask
    role_mask&.chars.map do |letter|
      ROLES[letter.upcase]
    end.compact
  end

  def auto_set_role
    self.update_column(:role_mask, "S") unless self.role_mask.present?
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def self.prepare_role_display(role)
    I18n.t(role, scope: :roles)
  end

  def self.roles_for_select
    ROLES.map { |key, value| [I18n.t(value, scope: :roles), key] }
  end


  def normalize_phone
    self.phone = Phonelib.parse(phone).full_e164.presence
  end

  private

    def password_validation?
      self.password
    end

    def self.ransackable_attributes(auth_object = nil)
      super & %w(
        name
      )
    end

end
