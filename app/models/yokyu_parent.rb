class YokyuParent < ApplicationRecord
  belongs_to :user
  has_many :yokyu_children
  has_many :yokyu_denpyos
  # self.per_page = 10
end
