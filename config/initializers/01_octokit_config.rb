stack = Faraday::RackBuilder.new do |builder|
  builder.use :http_cache, logger: Rails.logger, shared_cache: false, store: Rails.cache
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end

Octokit.middleware = stack
Octokit.configure do |c|
  c.access_token = Deployer.config.github_access_token
end
