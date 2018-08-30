module ExchangeCoinsService
  module Operations
    class BuildConference < BaseOperation
      attr_reader :resource

      def call(input)
        @resource = input[:resource]
        @resource.conference ||= create_conference

        Right input
      rescue Errno::ECONNREFUSED => e
        error_handler(e)
      end

      def create_conference
        create_chat_room
        conference_attributes
      end

      def conference_attributes
        Hash(
          name: resource.order_code.downcase,
          password: Devise.friendly_token(32),
          server: xmpp_conference_server,
          jid: [resource.order_code.downcase, xmpp_conference_server].join('@')
        )
      end

      def create_chat_room
        jid = [resource.order_code.downcase, xmpp_conference_server].join('@')

        JabberAdmin.create_room!(
          room: jid,
          host: xmpp_server
        )
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
