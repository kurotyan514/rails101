class Account::GroupsController < ApplicationController
	before_action :authenticate_user!

	def index
		
		@groups = current_user.participated_groups
		# @groups = current_user.groups
	end
end
