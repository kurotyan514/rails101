class PostsController < ApplicationController
	before_action :find_group_and_post
	before_action :authenticate_user!
	before_action :member_required , only:[:new,:create]
	before_action :check_is_from_account , only:[:edit,:destroy]
	def new
		#不懂為什麼是:group_id不是:id
		#puts "params~~~~~,#{params}"
		#put params的結果{"controller"=>"posts", "action"=>"new", "group_id"=>"3"}
		#在group下的post,所以要用group_id,因為也沒有:id這個屬性
		# @group = Group.find(params[:group_id])

		@post = @group.posts.new

		# puts "!!!!!!!!!!!#{@post.attributes}"
	end

	def create
		# puts "post_params~~~ , #{post_params}"

		# @group = Group.find(params[:group_id])
		@post = @group.posts.build(post_params)
		@post.author = current_user
		#puts "create22222222@post id ===== #{@post[:id]}"
		#@post = @group.posts.create(post_params)
		#用create也可以，為什麼要用build
		if @post.save
			#puts "create3333333@post id ===== #{@post[:id]}" 
			#要在save之後post才會有id
			redirect_to group_path(@group) , notice: "新增文章成功"
			# render :new
		else
			render :new
		end

	end

	def edit
		# @group = Group.find(params[:group_id])
		# @post = @group.posts.find(params[:id])
		
		
		
	end

	def update
		# @group = Group.find(params[:group_id])
		# @post = @group.posts.find(params[:id])
		if @post.update(post_params)
			
			if $is_from_account
				redirect_to account_posts_path , notice: "文章修改成功"
			else
				redirect_to group_path(@group) , notice: "文章修改成功"
			end
		else
			render :edit
		end
	end

	def destroy
		# @group = Group.find(params[:group_id])
		# @post = @group.posts.find(params[:id])
		@post.destroy
		if $is_from_account
				redirect_to account_posts_path , notice: "文章已刪除"
			else
				redirect_to group_path(@group) , alert: "文章已刪除"
		end
		
		# render :show
	end

	private
	def find_group_and_post
		@group = Group.find(params[:group_id])
		if params[:id] != nil
			# @post = @group.posts.find(params[:id])
			@post = current_user.posts.find(params[:id])
			# puts "find_group_and_post~~@post id ===== #{@post[:id]}"
		end

		
	end

	def member_required
		if !current_user.is_member_of?(@group)
			flash[:warning] = "你不是這個討論板的成員，不能發文喔"
			redirect_to group_path(@group);
		end
	end

	def post_params
	   params.require(:post).permit(:content)
	end

	def check_is_from_account
		$is_from_account = params[:from_account].to_b
	end


	
end
