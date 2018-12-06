class WatsonLanguageMaster < ApplicationRecord
    has_many :yokyu_denpyos
    has_many :watson_language_keywords
end
