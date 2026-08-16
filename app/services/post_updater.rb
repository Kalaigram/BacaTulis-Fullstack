class PostUpdater < ApplicationService
  attr_reader :post

  def initialize(post, params)
    @post = post
    @params = params
  end

  def call
    @post.update(@params)
    self
  end

  def success?
    @post.errors.empty?
  end

  def errors
    @post.errors
  end
end
