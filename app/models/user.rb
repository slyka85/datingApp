class User < ActiveRecord::Base

	has_many :friendships, dependent: :destroy
	has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
	has_attached_file :avatar, 
										:style => {:medium => '370x370', :thumb => '100x100'}
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
	default_scope { order('id DESC') }

	def self.sign_in_from_facebook(auth)
		find_by(provider: auth['provider'], uid: auth['uid']) || create_user_from_facebook(auth)
	end

	def self.create_user_from_facebook(auth)


where(provider: auth.provider, uid: auth.uid).first_or_create do |user|

      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.avatar = auth.info.image
	end
end


	# Friendship Methods
	def request_match(user2)
		self.friendships.create(friend: user2)
	end

		def accept_match(user2)
		self.friendships.where(friend: user2).first.update_attributes(state: "ACTIVE")
	end


		def remove_match(user2)
		
		inverse_friendship = inverse_friendships.where(user_id: user2).first

		if inverse_friendship
			self.inverse_friendships.where(user_id: user2).first.destroy
		else
			self.friendships.where(friend_id: user2).first.destroy
		end

	end

	#  Gender preferences
	def self.gender(user)
		case user.interest
			when "Male"
			where('gender = ?', 'male')
			when "Female" 
			where('gender = ?', 'female')
			else
			all
		end
	end

		def self.not_me(user)
		where.not(id: user.id)
	end

		def matches(current_user)
		friendships.where(state: "pending").map(&:friend) + current_user.friendships.where(state: "ACTIVE").map(&:friend) + current_user.inverse_friendships.where(state: "ACTIVE").map(&:user) 
	end

	private
	# def self.process_uri(uri)
	# 	avatar_url = URI.parse(uri)
	# 	avatar_url.scheme = 'https'
	# 	avatar_url.to_s
	# end
	def self.process_uri(uri)
  require 'open-uri'
  require 'open_uri_redirections'
  open(uri, :allow_redirections => :safe) do |r|
    r.base_uri.to_s
  end
end


end
