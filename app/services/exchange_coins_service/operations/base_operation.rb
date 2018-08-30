require 'dry/transaction/operation'

module ExchangeCoinsService
  module Operations
    class BaseOperation
      def self.inherited(klass)
        klass.send :include, Dry::Transaction::Operation
      end

      def call(input)
        # Provide custom behaviour for calling operation
        super(input)
      end

      private

      def current_user
        @current_user ||= RequestLocals.store[:current_user]
      end

      def reservation_service
        @reservation_service ||= ReservationService::Service.new
      end

      def xmpp_conference_server
        Rails.configuration.x.sko_web.xmpp_server_conference
      end
    end
  end
end
