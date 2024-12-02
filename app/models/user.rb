class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  before_save :normalize_phone
  after_create :auto_set_role
  after_create :set_default_avatar
  before_create :set_default_type

  validates :name, presence: true
  validates :password, length: {minimum: 8}, format: {with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{8,40}\z/, message: :invalid_password_format}, if: :password_validation?
  validates :phone, phone: true, allow_blank: true
  validate :acceptable_image

  has_many :messages, dependent: :destroy
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [70, 70]
  end

  ROLES = {
    "A" => "admin",
    "U" => "user"
  }

  def roles
    return [] unless role_mask
    role_mask&.chars.map do |letter|
      ROLES[letter.upcase]
    end.compact
  end

  def auto_set_role
    self.update_column(:role_mask, "U") unless self.role_mask.present?
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

  def acceptable_image
    if avatar.attached?
      acceptable_types = ["image/jpeg", "image/png", "image/tiff", "image/webp"]
      unless acceptable_types.include?(avatar.content_type)
        errors.add(:avatar, message: "musi być w formacie JPEG, PNG, WEBP lub AVIF")
      end
    end
  end

  def self.permitted_params
    # if self.type == "Teacher"
    #   default_params + Teacher.extra_params
    # elsif type == "Student"
    #   default_params + Student.extra_params
    # else
    #   default_params
    # end
    default_params
  end

  def self.default_params
    [:name, :email, :password, :password_confirmation, :phone, :role_mask, :avatar]
  end

  private

    def set_default_type
      self.type ||= 'Teacher'
    end

    def set_default_avatar
      unless avatar.attached?
        image_path = Rails.root.join("app/assets/images/default_user_avatar.png")
        avatar.attach(io: File.open(image_path), filename: 'default_user_avatar.png', content_type: 'image/png')
      end
    end

    def password_validation?
      self.password
    end

    def self.ransackable_attributes(auth_object = nil)
      super & %w(
        name
      )
    end

end
