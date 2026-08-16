class Current < ActiveSupport::CurrentAttributes
  attribute :session, :request_store, :user_agent, :ip_address

  delegate :user, to: :session, allow_nil: true
end
