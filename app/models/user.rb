class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


   has_many :books
  has_one_attached :profile_image  
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
    # フォローしている関連付け
  has_many :active_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy



   # フォロされている関連付け
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :followed_id, dependent: :destroy
  
    # フォローしているユーザーを取得
  has_many :followeds, through: :active_relationships, source: :followed
  # フォローされているユーザーを取
  has_many :followers, through: :passive_relationships, source: :follower

   # 指定したユーザーをフォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end
  
  # 指定したユーザーのフォローを解除する
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end
  
  # 指定したユーザーをフォローしているかどうかを判定
  def following?(user)
    followeds.include?(user)
  end

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true , presence: true
  validates :introduction, presence: true   


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def followed_by?(user)
    passive_relationships.find_by(follower_id: user.id).present?
  end
end
