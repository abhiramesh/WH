class Search < ActiveRecord::Base
   attr_accessible :user_id, :query

   belongs_to :user
   
end
