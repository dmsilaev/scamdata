class ApiController < ApplicationController
  include Pundit
  include Response
  include QuerableOptions
  include ExceptionHandler
  include DefaultsSerializeOptions

  ## Common parent
  # before_action :authenticate_user!
  # before_action :store_current_user

  # Enforces access right checks for individuals resources
  # after_action :verify_authorized, :except => :index

  # Enforces access right checks for collections
  # after_action :verify_policy_scoped, :only => :index

  private

  def store_current_user
    RequestLocals.store[:current_user] = current_user
  end
end
