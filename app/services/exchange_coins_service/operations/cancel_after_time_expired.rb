module ExchangeCoinsService
  module Operations
    class CancelAfterTimeExpired < BaseOperation
      include ExchangeCoinsService::Jobs::Import['cancel_after_time_expired_job']
      include ExchangeCoinsService::Jobs::Import['send_before_time_expired_notification']

      attr_reader :order, :expire_time

      def call(input)
        @order = input[:resource]
        @expire_time = order.expire_time

        send_expired_notifications([half_of_time, quarter_of_time])

        cancel_after_time_expired_job
          .set(wait_until: expire_time)
          .perform_later(order: order)
      end

      def half_of_time
        (diff_in_seconds/2)
      end

      def quarter_of_time
        (diff_in_seconds/4*3)
      end

      def diff_in_seconds
        @diff_in_seconds ||= begin
          time_exp = Time.zone.parse(expire_time.to_s)
          time_now = Time.zone.now

          time_exp - time_now
        end
      end

      def send_expired_notifications(times=[])
        times.each do |time|
          date_at = Time.zone.now + time.seconds

          options = {
            order: order,
            expires_at: ::Utils::PrettyTimeDuration.call((diff_in_seconds - time).to_i)
          }

          send_before_time_expired_notification
            .set(wait_until: date_at)
            .perform_later(options)
        end
      end
    end
  end
end
