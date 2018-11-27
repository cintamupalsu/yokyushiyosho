class YokyuChild < ApplicationRecord
  belongs_to :user
  belongs_to :yokyu_parent
  has_many :yokyu_child_denpyos
end
