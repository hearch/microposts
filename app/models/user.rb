class User < ActiveRecord::Base
  paginates_per 10
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :profile, length: { maximum: 140 }
  has_secure_password
  has_many :microposts
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  
  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower


  has_many :favorite_relationships, class_name: "Favorite",
                       foreign_key: "user_id",
                       dependent: :destroy

  has_many :favorite_microposts, through: :favorite_relationships, source: :micropost

  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.create(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).destroy
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end
  

  def feed_items
      Micropost.where(user_id: following_user_ids + [self.id])
  end
  
  # ポストをお気に入りする
  def favorite(other_micropost)
      favorite_relationships.create(micropost_id: other_micropost.id)
  end
      
  # ポストをお気に入りから外す
  def unfavorite(other_micropost)
      favorite_relationships.find_by(micropost_id: other_micropost.id).destroy
  end
    
  # あるポストをお気に入りしているかどうか？
  def favorite?(other_micropost)
      favorite_microposts.include?(other_micropost)
  end
  
end
  