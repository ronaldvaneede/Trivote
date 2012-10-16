class Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :itemgroup

  attr_accessible :archived, :name, :url, :description, :itemgroup_id

  acts_as_voteable
end
