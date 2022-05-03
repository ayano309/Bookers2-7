class UserRoom < ApplicationRecord
  #中間テーブル
  belongs_to :user
  belongs_to :room
end
