class Room < ApplicationRecord
  #１ユーザーが多くのuser_roomを保有しているので、１対多
  #１ユーザーが多くのchatを行うので、１対多
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
end
