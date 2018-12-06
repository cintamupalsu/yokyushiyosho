class YokyuDenpyo < ApplicationRecord
  belongs_to :user
  belongs_to :yokyu_parent
  belongs_to :file_manager
  belongs_to :watson_language_master
  default_scope -> { order(created_at: :desc) }

end
