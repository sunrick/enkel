class Enkel::Action
  class NotImplementedError < StandardError; end
  class HaltExecution < StandardError; end
  class InvalidStatusError < StandardError
    def initialize(status)
      super("Invalid status: #{status}")
    end
  end

  HTTP_STATUS_MAPPING = {
    continue: 100,
    switching_protocols: 101,
    processing: 102,
    early_hints: 103,
    ok: 200,
    created: 201,
    accepted: 202,
    non_authoritative_information: 203,
    no_content: 204,
    reset_content: 205,
    partial_content: 206,
    multi_status: 207,
    already_reported: 208,
    im_used: 226,
    multiple_choices: 300,
    moved_permanently: 301,
    found: 302,
    see_other: 303,
    not_modified: 304,
    use_proxy: 305,
    "(unused)": 306,
    temporary_redirect: 307,
    permanent_redirect: 308,
    bad_request: 400,
    unauthorized: 401,
    payment_required: 402,
    forbidden: 403,
    not_found: 404,
    method_not_allowed: 405,
    not_acceptable: 406,
    proxy_authentication_required: 407,
    request_timeout: 408,
    conflict: 409,
    gone: 410,
    length_required: 411,
    precondition_failed: 412,
    payload_too_large: 413,
    uri_too_long: 414,
    unsupported_media_type: 415,
    range_not_satisfiable: 416,
    expectation_failed: 417,
    misdirected_request: 421,
    unprocessable_entity: 422,
    locked: 423,
    failed_dependency: 424,
    too_early: 425,
    upgrade_required: 426,
    precondition_required: 428,
    too_many_requests: 429,
    request_header_fields_too_large: 431,
    unavailable_for_legal_reasons: 451,
    internal_server_error: 500,
    not_implemented: 501,
    bad_gateway: 502,
    service_unavailable: 503,
    gateway_timeout: 504,
    http_version_not_supported: 505,
    variant_also_negotiates: 506,
    insufficient_storage: 507,
    loop_detected: 508,
    bandwidth_limit_exceeded: 509,
    not_extended: 510,
    network_authentication_required: 511
  }.freeze

  attr_accessor :data

  # TODO:

  # USE CASES:
  # - USE ANYWHERE
  # - API endpoint
  # - HTTP Request replacement
  # - Background jobs
  # - Service objects
  # - Rails controller action replacement

  class << self
    def call(attributes = {})
      instance = new(**attributes)
      instance.call
      instance
    rescue Enkel::Action::HaltExecution
      instance
    rescue StandardError => error
      instance.error_handler(error)
      instance
    end

    # TODO: Raise error if errors present?
    def call!(attributes = {})
      instance = new(**attributes)
      instance.call
      instance
    rescue Enkel::Action::HaltExecution
      instance
    rescue StandardError => error
      instance.error_handler(error)
      raise error
    end
  end

  def call
    raise Enkel::Action::NotImplementedError
  end

  def respond(status = nil, object = nil)
    if status && status.respond_to?(:to_h)
      self.data = status
    else
      self.status = status if status
      self.data = object if object
    end
  end

  def respond!(status = nil, object = nil)
    respond(status, object)
    raise Enkel::Action::HaltExecution
  end

  def status
    @status ||= :ok
  end

  def status=(status)
    @status = status
    raise Enkel::Action::InvalidStatusError.new(status) unless code
  end

  def code
    HTTP_STATUS_MAPPING[status]
  end

  def error(key, value)
    @success = false
    self.status ||= :unprocessable_entity

    errors.add(key, value)
  end

  def errors
    @errors ||= Enkel::Errors.new
  end

  def data
    @data ||= {}
  end

  def success?
    return @success if defined?(@success)
    @success = code.between?(100, 399) && errors.empty?
  end

  def failure?
    !success?
  end

  def error_handler(error)
    self.status = :internal_server_error
  end
end
