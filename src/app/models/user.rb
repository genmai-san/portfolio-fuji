# frozen_string_literal: true

class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }
  validates :profile_photo, presence: true
  mount_uploader :profile_photo, ImageUploader

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
      user.profile_photo = Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/guest.png'), 'image/png')
    end
  end

  def liked_by?(post_id)
    likes.where(post_id: post_id).exists?
  end

  def update_without_current_password(params, *options)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end
end
