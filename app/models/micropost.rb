class Micropost < ActiveRecord::Base
    paginates_per 10
    belongs_to :user
    has_many :retweeter, :class_name => 'user'
    validates :user_id, presence: true
    validates :content, presence: true, length: { maximum: 140 }
end
