class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :books ,dependent: :destroy
  has_many :comments ,dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  #follower
  has_many :following_relationships, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy
  has_many :followings, through: :following_relationships, source: :following
  
  has_many :follower_relationships, foreign_key: 'following_id', class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower
  
  #DMチャット
  #ユーザーは多くのuser_roomを持っていて多くのメッセージ（chat）を発言できる
  has_many :user_rooms, dependent: :destroy
  has_many :chats,dependent: :destroy
  #中間テーブルを通して相手がいる分の部屋を持っている
  has_many :rooms, through: :user_rooms
  
  has_one_attached :profile_image
  
  validates :name, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }
  
  
  
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no-image.jpeg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
  
  def follow!(user)
    user_id = get_user_id(user)
     
    following_relationships.create!(following_id: user_id)
  end
  
  def unfollow!(user)
    user_id = get_user_id(user)
    
    relation = following_relationships.find_by!(following_id: user_id)
    relation.destroy!
  end
  
  def has_followed?(user)
    following_relationships.exists?(following_id: user.id)
  end
  
  private
  def get_user_id(user)
    if user.is_a?(User)
      user.id
    else
      user
    end
  end
  
  
end
