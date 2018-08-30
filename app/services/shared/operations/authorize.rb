require 'pundit'
require 'dry/transaction/operation'

module Shared
  module Operations
    class Authorize
      include Dry::Transaction::Operation

      attr_accessor :action, :resource

      def call(input, action, model)
        @action = action
        @resource = input[:resource] || model

        policy_check ? success_handler(input) : error_handler
      end

      def policy_check
        return false if current_user.nil?
        Pundit.policy(current_user, resource).send("#{action}?")
      end

      def success_handler(result)
        Right result.merge(current_user: current_user)
      end

      def error_handler
        data = {
          code: :forbidden,
          messages: ['Доступ запрещен']
        }

        Left(data)
      end

      def current_user
        @current_user ||= RequestLocals.store[:current_user]
      end
    end
  end
end
