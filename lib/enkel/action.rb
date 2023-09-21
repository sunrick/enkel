class Enkel::Action
  class NotImplementedError < StandardError; end
  class HaltExecution < StandardError; end

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
      instance.response
    rescue Enkel::Action::HaltExecution
      instance.response
    rescue StandardError => error
      instance.error_handler(error)
      instance.response
    end

    # TODO: Raise error if errors present?
    def call!(attributes = {})
      instance = new(**attributes)
      instance.call

      if instance.response.errors?
        raise Enkel::Response::Errors, instance.response.errors
      end

      instance.response
    rescue Enkel::Action::HaltExecution
      instance.response
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
      response.data = status
    else
      response.status = status if status
      response.data = object if object
    end
  end

  def respond!(status = nil, object = nil)
    respond(status, object)
    raise Enkel::Action::HaltExecution
  end

  def response
    @response ||= Enkel::Response.new
  end

  def error(key, value)
    response.error(key, value)
  end

  def error_handler(error)
    response.status = :internal_server_error
  end
end
