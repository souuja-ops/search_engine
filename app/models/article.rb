class Article < ApplicationRecord
    include Ransack::Adapters::ActiveRecord::Base

    def self.ransackable_attributes(auth_object = nil)
        ["title"] 
    end
  
    
end
  