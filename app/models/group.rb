class Group < ApplicationRecord
 validates :name, presence: true
  validates :introduction, presence: true
  has_one_attached :group_image
   has_many :group_users, dependent: :destroy
 has_many :users, through: :group_users, source: :user
  belongs_to :owner, class_name: "User"

  def get_group_image
    (group_image.attached?) ? group_image : 'no_image.jpg'
  end

  def is_owned_by?(user)
    owner.id == user.id
  end

  def include_user?(user)
    group_users.exists?(user_id: user.id)
  end
end
