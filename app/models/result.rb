class Result < ActiveRecord::Base
   attr_accessible :user_id, :query, :name, :image_url

   belongs_to :user

end
