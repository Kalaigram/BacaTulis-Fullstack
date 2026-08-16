class PostCreator < ApplicationService
  attr_reader :post

  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    @post = @user.posts.build(@params)
    @post.save
    self
  end

  def success?
    @post.persisted?
  end

  def errors
    @post.errors
  end
end
