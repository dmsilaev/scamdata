require_relative './base_operation'

module ExchangeCoinsService
  module Operations
    class SubscribeBotToConference < BaseOperation
      attr_reader :order

      def call(input)
        @order = input[:resource]
        subscribe_bot_to_conference


        Right(input)
      rescue => e
        error_handler(e)
      end

      def subscribe_bot_to_conference
        conference_jid = order.conference.jid

        service = SubscribeBotToConferenceService
        service.setup ENV['XMPP_BOT'], ENV['XMPP_BOT_PASSWORD'], ENV['XMPP_SERVER'], ENV['XMPP_CONFERENCE_PORT']

        EM.run do
          service.call(
            conference_jid: order.conference.jid,
            bot_jid: ENV['XMPP_BOT'],
            bot_nickname: "bot/sko"
          )
        end
      end

      def error_handler(error)
        data = {
          code: :internal_server_error,
          messages: [error.message]
        }

        Left(data)
      end
    end
  end
end
