class FriendshipsController < ApplicationController
	before_action :require_login
	before_action :set_friend

	def create
	end


	def destroy
	end

	private
	def set_friend
		@friend = User.find(params[:friend_id])
	end
end
