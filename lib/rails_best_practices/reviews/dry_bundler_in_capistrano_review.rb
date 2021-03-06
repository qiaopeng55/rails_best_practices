# encoding: utf-8
require 'rails_best_practices/reviews/review'

module RailsBestPractices
  module Reviews
    # Review config/deploy.rb file to make sure using the bundler's capistrano recipe.
    #
    # See the best practice details here http://rails-bestpractices.com/posts/51-dry-bundler-in-capistrano
    #
    # Implementation:
    #
    # Review process:
    #   only check the call nodes to see if there is bundler namespace in config/deploy.rb file,
    #
    #   if the message of call node is :namespace and the arguments of the call node is :bundler,
    #   then it should use bundler's capistrano recipe.
    class DryBundlerInCapistranoReview < Review
      def url
        "http://rails-bestpractices.com/posts/51-dry-bundler-in-capistrano"
      end

      def interesting_nodes
        [:call]
      end

      def interesting_files
        /config\/deploy.rb/
      end

      # check call node to see if it is with message :namespace and arguments :bundler.
      #
      # the ruby code is
      #
      #     namespace :bundler do
      #       ...
      #     end
      #
      # then the call node is as follows
      #
      #     s(:call, nil, :namespace, s(:arglist, s(:lit, :bundler)))
      def start_call(node)
        if :namespace == node.message and equal?(node.arguments[1], "bundler")
          add_error "dry bundler in capistrano"
        end
      end
    end
  end
end
