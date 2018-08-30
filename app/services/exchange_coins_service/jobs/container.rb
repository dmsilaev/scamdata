module ExchangeCoins
  module Jobs
    class Container
      extend Dry::Container::Mixin

      register("send_cancel_notification") { SendCancelNotification }
      register("send_change_notification") { SendChangeNotification }
      register("send_confirm_notification") { SendConfirmNotification }
      register("send_create_notification") { SendCreateNotification }
      register("cancel_after_time_expired_job") { CancelAfterTimeExpiredJob }
      register("send_before_time_expired_notification") { SendBeforeTimeExpiredNotification }
    end
  end
end
