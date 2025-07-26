Rack::Attack.throttle('req/ip', limit: 300, period: 5.minutes) do |req|
  req.ip unless req.path.start_with?('/assets')
end

Rack::Attack.throttle(
    'logins/ip',
    limit: ENV.fetch('LOGIN_THROTTLE_REQUESTS', 10).to_i,
    period: ENV.fetch('LOGIN_THROTTLE_SECONDS', 20).to_i.seconds
  ) do |req|
    req.ip if req.path == '/accounts/sign_in' && req.post?
  end

Rack::Attack.blocklist("block ip") do |req|
    Rails.cache.read("block #{req.ip}")
  end

  denied = ENV.fetch('RACKATTACK_DENY', "").split(/,\s*/)
  denied_regexp = Regexp.union(denied)
Rack::Attack.blocklist("refspam") do |request|
    request.referer =~ denied_regexp
  end

Rack::Attack.throttle(
    "logins/email",
    limit: ENV.fetch('LOGIN_THROTTLE_REQUESTS', 10).to_i,
    period: ENV.fetch('LOGIN_THROTTLE_SECONDS', 20).to_i.seconds
  ) do |req|
    req.params['email'].presence if req.path == '/accounts/sign_in' && req.post?
  end

class Rack::Attack
  self.blocklisted_responder = lambda do
    [ENV.fetch('THROTTLED_RESPONSE_CODE', 418), {}, ['']]
  end

  self.throttled_responder = lambda do
    [ENV.fetch('THROTTLED_RESPONSE_CODE', 418), {}, ['']]
  end
end
