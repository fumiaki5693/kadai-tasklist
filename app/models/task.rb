class Task < ApplicationRecord
  belongs_to :user
  
  validates :content, presence: true, length: { maximum: 50 }
  validates :status, presence: true, length: { maximum:255 }
end
