require 'dry-container'

module ExchangeCoinsService
  module Operations
    class Container
      extend Dry::Container::Mixin
      import Shared::Container

      register('build') { Build.new }
      register('make_reservations') { MakeReservations.new }
      register('confirm') { Confirm.new }
      register('cancel') { Cancel.new }
      register('persist') { Persist.new }
      register('present') { Present.new }
      register('scope') { Scope.new }
      register('sort') { Sort.new }
      register('filter') { Filter.new }
      register('send_create_notification') { SendCreateNotification.new }
      register('send_confirm_notification') { SendConfirmNotification.new }
      register('send_cancel_notification') { SendCancelNotification.new }
      register('send_change_notification') { SendChangeNotification.new }
      register('cancel_after_time_expired') { CancelAfterTimeExpired.new }
      register('get_conference') { GetConference.new }
      register('can_manage') { CanManage.new }
      register('build_conference') { BuildConference.new }
      register('subscribe_bot_to_conference') { SubscribeBotToConference.new }
    end
  end
end
