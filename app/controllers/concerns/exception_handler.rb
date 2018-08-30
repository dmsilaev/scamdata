module ExceptionHandler
  extend ActiveSupport::Concern


  included do
    rescue_from Pundit::NotAuthorizedError, with: :forbidden
    rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found

    def forbidden
      head :forbidden
    end

    def not_found
      head :not_found
    end

    def unauthorized
      head :unauthorized
    end
  end
end
