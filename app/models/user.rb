class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :books , dependent: :destroy
  has_one_attached :profile_image  
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :rooms, through: :entries
  has_many :view_counts, dependent: :destroy
  has_many :group_users, dependent: :destroy

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true , presence: true
  validates :introduction, presence: true   
  
    # フォローしている関連付け
  has_many :active_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
    # フォローしているユーザーを取得
  has_many :followeds, through: :active_relationships, source: :followed

   # フォロされている関連付け
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :followed_id, dependent: :destroy
  # フォローされているユーザーを取得
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

    def followed_by?(user)
    passive_relationships.find_by(follower_id: user.id).present?
  end


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end



  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end

  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'guestuser'
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end  

end
