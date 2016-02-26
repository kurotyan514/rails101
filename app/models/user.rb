class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :groups
  has_many :posts
  has_many :group_users
  has_many :participated_groups , through: :group_users , source: :group

  def is_member_of?(group)
  	participated_groups.include?(group)
    # group_users.where(:group_id => group.id).present?
  end

 
  def join!(group)
    # binding.pry
  	participated_groups << group
    # group_users.create(:group_id => group.id)
  end
  def quit!(group)
    binding.pry
  	participated_groups.delete(group)
  end

end
