require 'spec_helper'

describe RailsBestPractices::Reviews::UseModelAssociationReview do
  let(:runner) { RailsBestPractices::Core::Runner.new(:reviews => RailsBestPractices::Reviews::UseModelAssociationReview.new) }

  it "should use model association for instance variable" do
    content = <<-EOF
    class PostsController < ApplicationController

      def create
        @post = Post.new(params[:post])
        @post.user_id = current_user.id
        @post.save
      end
    end
    EOF
    runner.review('app/controllers/posts_controller.rb', content)
    runner.should have(1).errors
    runner.errors[0].to_s.should == "app/controllers/posts_controller.rb:3 - use model association (for @post)"
  end

  it "should not use model association without association assign" do
    content = <<-EOF
    class PostsController < ApplicationController

      def create
        @post = Post.new(params[:post])
        @post.save
      end
    end
    EOF
    runner.review('app/controllers/posts_controller.rb', content)
    runner.should have(0).errors
  end

  it "should use model association for local variable" do
    content = <<-EOF
    class PostsController < ApplicationController

      def create
        post = Post.new(params[:post])
        post.user_id = current_user.id
        post.save
      end
    end
    EOF
    runner.review('app/controllers/posts_controller.rb', content)
    runner.should have(1).errors
    runner.errors[0].to_s.should == "app/controllers/posts_controller.rb:3 - use model association (for post)"
  end

  it "should not use model association" do
    content = <<-EOF
    class PostsController < ApplicationController

      def create
        post = current_user.posts.buid(params[:post])
        post.save
      end
    end
    EOF
    runner.review('app/controllers/posts_controller.rb', content)
    runner.should have(0).errors
  end
end
