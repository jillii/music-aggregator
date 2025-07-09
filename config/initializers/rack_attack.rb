class Rack::Attack
  Rack::Attack.throttle("users/sign_up", limit: 3, period: 15.minutes) do |req|
    req.ip if req.path == "/users" && req.post?
  end
end if Rails.env.production?