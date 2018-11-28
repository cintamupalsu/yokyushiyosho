class YokyuDenpyo < ApplicationRecord
  belongs_to :user
  belongs_to :yokyu_parent
  belongs_to :file_manager
  default_scope -> { order(created_at: :desc) }

end
