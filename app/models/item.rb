class Item < ActiveRecord::Base
  belongs_to :user
  attr_accessible :archived, :name, :url

  acts_as_voteable
end
