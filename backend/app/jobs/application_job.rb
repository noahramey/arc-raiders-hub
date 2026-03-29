class ApplicationJob < ActiveJob::Base
  queue_as :default

  retry_on MetaForgeService::ApiError, wait: :polynomially_longer, attempts: 3
  discard_on MetaForgeService::NotFoundError
end
