module ExchangeCoinsService
  module Operations
    class Build < BaseOperation
      attr_reader :attributes

      def call(input)
        @attributes = input[:attributes]

        order_attributes = attributes.deep_dup
          .without(:reservations)
          .with_indifferent_access
          .merge(hotel_attributes)

        order = get_order(order_attributes)

        Right input.merge(resource: order)
      end

      def hotel_attributes
        hotel_id = attributes[:reservations][0][:hotel][:id]
        Hash(hotel: Hotel.find(hotel_id))
      end

      def get_order(order_attributes)
        find_order(order_attributes)
      rescue Mongoid::Errors::DocumentNotFound
        init_order(order_attributes)
      end

      def find_order(order_attributes)
        code = order_attributes[:order_code]
        ExchangeCoinsService.find_by(order_code: code)
      end

      def init_order(order_attributes)
        attributes = order_attributes.tap do |params|
          params[:source] = get_source(params)

          order_code = params[:order_code] || ::Utils::TokenGenerator.generate("%C%C-%d%d%d%d")
          params[:order_code] = order_code
        end

        ExchangeCoinsService.new(attributes)
      end


      def map_contacts(contacts)
        contacts
          .map { |contact| map_contact(contact) }
          .compact
      end

      def map_contact(contact)
        case contact[:type]
        when :phone
          phone_attributes = contact.slice(:number, :suffix)
          ContactPhone.find_or_initialize_by(phone_attributes)
        else
          nil
        end
      end

      def get_manager(creator_attributes)
        manager = InsuranceManager.find_or_initialize_by(
          creator_attributes.slice(:email)
        )

        manager_attributes = creator_attributes.tap do |params|
          contacts = params.delete(:contacts) || []
          params[:contacts] = map_contacts(contacts)
        end

        manager.update!(manager_attributes)

        manager
      end

      def get_source(params={})
        if current_user.requested_by?(:insurance)
          creator = params.delete(:creator)
          manager = get_manager(creator)
          get_insurance_source(manager)
        else
          get_client_source
        end
      end

      def get_insurance_source(manager)
        InsuranceSource.new(manager: manager, source: current_user)
      end

      def get_client_source
        ClientSource.new(manager: current_user, source: current_user.hotel)
      end
    end
  end
end
