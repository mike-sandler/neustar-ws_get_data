# Base client used to interface with WS-GetData query and batch_query services.
class Neustar::WsGetData::Client
  # Maximum transaction ID:
  MAX_TRANSACTION_ID = 1_000_000

  # @param [Hash] options The configuration options
  # @option options [String] :username Name of the Neustar account
  # @option options [String] :password Password for the Neustar account
  # @option options [String] ::service_id Service ID for the Neustar account
  def initialize(options = {})
    @service    = Savon.client(:wsdl => Neustar::WsGetData::WSDL)
    @username   = options[:username] or
                    raise ConfigurationError, "Username required"
    @password   = options[:password] or
                    raise ConfigurationError, "Password required"
    @service_id = options[:service_id] or
                    raise ConfigurationError, "Service ID required"
  end

  # List the operations available to the client.
  #
  # @return [Array<Symbol>]
  def operations
    @service.operations
  end

  # Execute an 'interactive' query.
  #
  # @param [Hash] params
  # @return [Hash]
  def query(params)
    call(:query, params)
  end

  # Execute a batch query.
  #
  # @param [Hash] params
  # @return [Hash]
  def batch_query(params)
    call(:batch_query, params)
  end

  # Execute a call to the given service type.
  #
  # @param [Symbol] service
  # @return [Hash]
  def call(service, params)
    transaction_id = params.fetch(:transaction_id) { build_transaction_id }

    message = origination_params.
              merge(:transId => transaction_id).
              merge(params)

    begin
      response = @service.call(service, :message => message)
      process_response(service, response)
    rescue Savon::SOAPFault => error
      raise Neustar::Error, extract_fault_message(error)
    end
  end

  # Execute initial post-processing and error handling on the response.
  #
  # @param [Symbol] service
  # @param [Savon::Response] response
  #
  # @return [Hash]
  def process_response(service, response)
    response_wrapper = response.body[:"#{service}_response"]
    response_wrapper && response_wrapper[:response]
  end

  # Helper to access PhoneAttributes element.
  # TODO: Refactor out of here
  #
  # @param [#to_s] phone_number
  # @param [Array<Symbol>] indicators
  def phone_attributes(phone_number, indicators = [])
    Neustar::WsGetData::PhoneAttributes.query(self, phone_number, indicators)
  end

  # Parameters used to authenticate the client.
  #
  # @return [Hash]
  def origination_params
    {
      :origination => {
        :username => @username, :password => @password
      },
      :serviceId   => @service_id.to_s
    }
  end

  # Returns a unique transaction ID to send with each request.
  #
  # @return [String]
  def build_transaction_id
    SecureRandom.random_number(MAX_TRANSACTION_ID)
  end

  # Pulls the error message from a Savon::SOAPFault exception.
  #
  # @param [Savon::SOAPFault] error
  # @return [String]
  def extract_fault_message(error)
    data = error.to_hash

    if (fault = data[:fault]) and (faultstring = fault[:faultstring]) then
      faultstring
    else
      "Unknown Error"
    end
  end
  private :extract_fault_message
end
