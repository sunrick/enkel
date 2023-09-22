class Enkel::Action
  class NotImplementedError < StandardError
  end
  class HaltExecution < StandardError
  end

  @@debug = false

  # TODO:

  # USE CASES:
  # - USE ANYWHERE
  # - API endpoint
  # - HTTP Request replacement
  # - Background jobs
  # - Service objects
  # - Rails controller action replacement

  class << self
    def before_hooks
      @before_hooks ||= []
    end

    def around_hooks
      @around_hooks ||= []
    end

    def after_hooks
      @after_hooks ||= []
    end

    def before(method_name)
      before_hooks << method_name
    end

    def around(method_name)
      around_hooks << method_name
    end

    def after(method_name)
      after_hooks << method_name
    end

    def call(attributes = {}, &block)
      instance = new(**attributes)

      before_hooks.each { |hook| instance.send(hook) }
      around_hooks.each { |hook| instance.send(hook) { instance.call } }
      after_hooks.each { |hook| instance.send(hook) }

      yield(instance.response) if block_given?

      instance.response
    rescue Enkel::Action::HaltExecution
      yield(instance.response) if block_given?
      instance.response
    rescue StandardError => error
      if instance
        instance.error_handler(error)
        yield(instance.response) if block_given?
        raise error if debug
        instance.response
      else
        Enkel::Response.new(
          status: :internal_server_error,
          errors: {
            server: ["internal server error"]
          }
        )
      end
    end

    def call!(attributes = {})
      instance = new(**attributes)

      before_hooks.each { |hook| instance.send(hook) }
      around_hooks.each { |hook| instance.send(hook) { instance.call } }
      after_hooks.each { |hook| instance.send(hook) }

      if instance.errors?
        raise Enkel::Response::Errors, instance.response.errors
      end

      yield(instance.response) if block_given?

      instance.response
    rescue Enkel::Action::HaltExecution
      yield(instance.response) if block_given?
      instance.response
    rescue Enkel::Response::Errors => error
      raise error
    rescue StandardError => error
      if instance
        instance.error_handler(error)
        yield(instance.response) if block_given?
      end
      raise error
    end

    def debug=(value)
      @@debug = value
    end

    def debug(&block)
      if block_given?
        self.debug = true
        yield
      end

      @@debug
    ensure
      self.debug = false if block_given?
    end
  end

  def call
    raise Enkel::Action::NotImplementedError
  end

  def respond(status = nil, hash = nil)
    if status && status.respond_to?(:to_h)
      response.data = status
    else
      response.status = status if status
      response.data = hash if hash
    end
  end

  def respond!(status = nil, object = nil)
    respond(status, object)
    raise Enkel::Action::HaltExecution
  end

  def response
    @response ||= Enkel::Response.new
  end

  def errors?
    response.errors?
  end

  def data
    response.data
  end

  # TODO: Integrate with ActiveModel::Errors?
  # TODO: Integrate with Dry::Validation?
  # TODO: Integrate with I18n?
  def error(hash)
    response.error(hash)
  end

  def error!(hash)
    error(hash)
    halt_execution!
  end

  def error_handler(error)
    response.status = :internal_server_error
    error(server: "internal server error")
  end

  def merge(other_response)
    if other_response.success?
      response.data.merge!(other_response.data)
    else
      error other_response.errors
    end
  end

  def merge!(other_response)
    if other_response.success?
      response.data.merge!(other_response.data)
    else
      error! other_response.errors
    end
  end

  def halt_execution!
    raise Enkel::Action::HaltExecution
  end
end
