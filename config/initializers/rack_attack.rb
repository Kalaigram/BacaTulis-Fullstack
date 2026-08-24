# frozen_string_literal: true

class Rack::Attack
  # Throttle API requests by IP (60 requests per minute)
  throttle("api/ip", limit: 60, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/api/")
  end

  # Throttle API requests by user token (100 requests per minute)
  throttle("api/token", limit: 100, period: 1.minute) do |req|
    if req.path.start_with?("/api/")
      req.env["HTTP_AUTHORIZATION"]&.split(" ")&.last
    end
  end

  # Throttle login attempts by IP (5 requests per 20 seconds)
  throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    req.ip if req.path == "/session" && req.post?
  end

  # Throttle registration attempts by IP (3 requests per minute)
  throttle("registrations/ip", limit: 3, period: 1.minute) do |req|
    req.ip if req.path == "/registration" && req.post?
  end

  # Custom response for throttled requests
  self.throttled_response = lambda do |env|
    retry_after = (env["rack.attack.match_data"] || {})[:period]
    [
      429,
      { "Content-Type" => "application/json", "Retry-After" => retry_after.to_s },
      [ { error: "Too many requests. Please try again later." }.to_json ]
    ]
  end
end

# Notify on throttled requests
ActiveSupport::Notifications.subscribe("rack.attack") do |name, start, finish, request_id, payload|
  req = payload[:request]
  if req.env["rack.attack.matched"] == "api/ip" || req.env["rack.attack.matched"] == "api/token"
    Rails.logger.warn "[Rack::Attack] Throttled: #{req.env["rack.attack.matched"]} from #{req.ip}"
  end
end
