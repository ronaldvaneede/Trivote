class Itemgroup < ActiveRecord::Base
  attr_accessible :name
  has_many :items
end
