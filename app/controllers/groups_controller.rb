class GroupsController < ApplicationController
	before_action :authenticate_user!,only:[:new,:edit,:create,:update,:destroy]
	before_action :find_group , only:[:edit,:update,:destroy]
	before_action :check_is_from_account , only:[:edit,:destroy]
	def index
		#flash[:notice] = "good morning"
		#flash[:alert] = " morning"
		#flash[:warning] = "這是 warning 訊息！"
		@groups = Group.all
	end

	def new
		@group = Group.new
	end

	def show

		@group = Group.find(params[:id])
		@posts = @group.posts
	end

	def edit
		# @group = Group.find(params[:id])
	end

	def update
		# @group = Group.find(params[:id]);
		if @group.update(group_params)
			if $is_from_account
				redirect_to account_groups_path , notice: "文章修改成功"
			else
				redirect_to groups_path , notice: "修改討論板成功"
			end

		else
			render :edit
		end
	end

	def destroy

		@group = current_user.groups.find(params[:id]);
		binding.pry
		# @group.group_users.delete_all
    @group.destroy
		# @group = Group.find(params[:id])
		# @group = current_user.groups.find(params[:id])

		# @group.destroy
		if $is_from_account
				redirect_to account_groups_path , notice: "文章已刪除"
			else
				redirect_to groups_path(@group) , alert: "文章已刪除"
		end

	end

	def create

		# @group = Group.create(group_params);

		@group = current_user.groups.create(group_params)

		if @group.save
			current_user.join!(@group)
			redirect_to groups_path
		else
			render :new
		end
	end

	def join

		@group = Group.find(params[:id])
		if !current_user.is_member_of?(@group)
			current_user.join!(@group)
			flash[:warning] = "你已經是討論板成員"

		else
			flash[:warning] = "你不是本討論版成員，怎麼退出 XD"
		end

		redirect_to group_path(@group)
	end

	def quit

	   @group = Group.find(params[:id])

	   if current_user.is_member_of?(@group)
	     current_user.quit!(@group)
	     flash[:alert] = "已退出本討論版！"
	   else
	     flash[:warning] = "你不是本討論版成員，怎麼退出 XD"
	   end

	   redirect_to group_path(@group)
	 end


	private
	def find_group
		@group = current_user.groups.find(params[:id])
	end

	def group_params

		params.require(:group).permit(:title,:description)
	end
	def check_is_from_account
		$is_from_account = params[:from_account].to_b
	end
end
