class YokyuParentDenpyo < ApplicationRecord
  belongs_to :yokyu_parent
  has_many :yokyu_child_denpyos
end
