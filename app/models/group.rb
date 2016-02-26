class Group < ActiveRecord::Base
	validates :title ,presence: true
	has_many :posts, dependent: :destroy
	belongs_to :owner , class_name: "User" , foreign_key: :user_id
	# has_many :group_users
	has_many :group_users , dependent: :destroy
	has_many :members , through: :group_users , source: :user
	#這邊的 :owner 等同於 :user , :owner這個欄位可以任意指定名稱，但不管什麼名稱都還是對應到User這個model
	# 不用:user、而用:owner的好處是？

	def editable_by?(user)
		user && user == owner
	end
 

end
