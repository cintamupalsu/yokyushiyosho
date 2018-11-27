class Company < ApplicationRecord
  belongs_to :company_type
  belongs_to :user
end
