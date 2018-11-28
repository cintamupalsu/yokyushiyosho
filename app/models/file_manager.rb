class FileManager < ApplicationRecord
  belongs_to :user
  has_many :yokyu_denpyos, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
end
