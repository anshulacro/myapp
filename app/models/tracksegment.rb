class Tracksegment < ActiveRecord::Base
  belongs_to :track
  has_many :points, :dependent => :destroy
  # attr_accessible :title, :body
end
