# MetaForgeService — central HTTP adapter for the MetaForge community API.
#
# All requests to metaforge.app/api/arc-raiders flow through this file.
# If the API changes its endpoints or response shape, this is the ONLY file
# to update. Sync jobs call the public class methods and receive plain Ruby
# arrays of hashes — they should not know or care about HTTP details.
#
# Attribution: data provided by MetaForge (metaforge.app/arc-raiders).
# Commercial use requires contacting them via Discord first.
#
# API version: v1 — bump API_VERSION and update ENDPOINTS if MetaForge changes.

class MetaForgeService
  class Error < StandardError; end
  class NotFoundError < Error; end
  class ApiError < Error
    attr_reader :status

    def initialize(msg, status: nil)
      super(msg)
      @status = status
    end
  end

  BASE_URL     = "https://metaforge.app/api/arc-raiders"
  API_VERSION  = "v1"

  # Endpoint paths relative to BASE_URL.
  # Update these if MetaForge changes their API without notice.
  ENDPOINTS = {
    items:   "/#{API_VERSION}/items",
    quests:  "/#{API_VERSION}/quests",
    arcs:    "/#{API_VERSION}/arcs",
    traders: "/#{API_VERSION}/traders",
    maps:    "/#{API_VERSION}/maps",
    events:  "/#{API_VERSION}/events"
  }.freeze

  class << self
    def items      = new.fetch(:items)
    def quests     = new.fetch(:quests)
    def arcs       = new.fetch(:arcs)
    def traders    = new.fetch(:traders)
    def maps       = new.fetch(:maps)
    def events     = new.fetch(:events)
  end

  # Fetches the full list for a given resource key.
  # Returns an Array of Hashes (parsed JSON).
  # Raises MetaForgeService::ApiError on non-2xx or network issues.
  def fetch(resource)
    path = ENDPOINTS.fetch(resource) { raise ArgumentError, "Unknown resource: #{resource}" }
    response = connection.get(path)
    handle_response(response)
  end

  private

  def connection
    @connection ||= Faraday.new(url: BASE_URL) do |f|
      f.request  :json
      f.response :json, content_type: /\bjson$/
      f.request  :retry, max: 3, interval: 1.0, backoff_factor: 2,
                         exceptions: [Faraday::TimeoutError, Faraday::ConnectionFailed]
      f.adapter  Faraday.default_adapter
      f.options.timeout      = 15
      f.options.open_timeout = 5
    end
  end

  def handle_response(response)
    case response.status
    when 200..299
      body = response.body
      # Normalise: some endpoints wrap data in a root key, others return a bare array.
      body.is_a?(Array) ? body : Array.wrap(body["data"] || body)
    when 404
      raise NotFoundError, "MetaForge returned 404"
    else
      raise ApiError.new(
        "MetaForge API error (HTTP #{response.status}): #{response.body}",
        status: response.status
      )
    end
  end
end
