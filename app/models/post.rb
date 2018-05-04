class Post < ApplicationRecord
  acts_as_paranoid
  has_one_attached :file
end
