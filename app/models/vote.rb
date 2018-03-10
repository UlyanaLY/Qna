# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, optional: true
end