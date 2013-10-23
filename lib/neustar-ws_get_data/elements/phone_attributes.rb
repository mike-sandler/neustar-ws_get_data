# From the documentation:
#
# "Element ID 1320 accepts a phone number and returns attributes associated
# with the phone number. Currently, the following attributes are available:
# Prepaid Phone Indicator, Business Phone Indicator (BPI), Phone In-Service
# Indicator, and Phone Type Indicator."
module Neustar::WsGetData::PhoneAttributes
  extend self

  # Error raised when an invalid phone number is sent to the service.
  class OutOfDomainError < Neustar::Error; end

  # ID for "Phone Attributes".
  ELEMENT_ID = 1320

  # Service ID to specify the telephone number in a request.
  TELEPHONE_SPECIFICATION_SERVICE_ID = 1

  # Service ID to specify which attributes we want returned.
  PHONE_ATTRIBUTES_REQUESTED_SERVICE_ID = 599

  # Mappings to request certain indicators from the service.
  INDICATORS = {
    :prepaid_phone    => 1,
    :business_phone   => 2,
    :phone_in_service => 3,
    :phone_type       => 4,
  }

  # Whether or not a phone is prepaid.
  PREPAID_PHONE_ATTRIBUTE_MAP = {
    'Y' => true,
    'N' => false
  }

  # The assumed purpose for a phone.
  BUSINESS_PHONE_INDICATOR_MAP = {
    'B' => :business_phone,
    'C' => :residential_phone,
    'D' => :dual_phone,
    'U' => :unknown
  }

  # The Phone In-Service field indicates whether the phone is active and
  # provides a range indicator for the active/inactive status.
  PHONE_IN_SERVICE_INDICATOR_MAP = {
    'A1' => "Active for 1 month or less",
    'A2' => "Active for 2 months",
    'A3' => "Active for 3 months",
    'A4' => "Active for between 4-6 months",
    'A5' => "Active for between 7-9 months",
    'A6' => "Active for between 10-11 months",
    'A7' => "Active for 12 months or longer",
    'I1' => "Inactive for 1 month or less",
    'I2' => "Inactive for 2 months",
    'I3' => "Inactive for 3 months",
    'I4' => "Inactive for between 4-6 months",
    'I5' => "Inactive for between 7-9 months",
    'I6' => "Inactive for between 10-11 months",
    'I7' => "Inactive for 12 months or longer",
    'U'  => "Status Unknown",
  }

  # The type of phone used.
  PHONE_TYPE_INDICATOR_MAP = {
    'W' => :wireless,
    'L' => :landline,
    'U' => :unknown
  }

  # A map between each attribute and their possible values.
  INDICATOR_MAPPINGS = {
    :prepaid_phone    => PREPAID_PHONE_ATTRIBUTE_MAP,
    :business_phone   => BUSINESS_PHONE_INDICATOR_MAP,
    :phone_in_service => PHONE_IN_SERVICE_INDICATOR_MAP,
    :phone_type       => PHONE_TYPE_INDICATOR_MAP
  }

  # Indicates that an invalid phone number was sent to the service.
  OUT_OF_DOMAIN_ERROR = "6"

  # Method used to execute a query against the Phone Attributes element of the
  # WS-GetData Service.
  #
  # @param [Neustar::WsGetData::Client] client
  # @param [#to_s] phone_number
  # @param [Array<Symbol>] indicators
  #
  # @return [Hash]
  def query(client, phone_number, indicators = [])
    indicators = parse_indicators(indicators)

    params = {
      :phone_number => phone_number,
      :indicators   => indicators
    }

    process_response(execute_request(client, params), params)
  end

  # Assemble and execute a query using the passed client.
  #
  # @param [Neustar::WsGetData::Client] client
  # @param [Hash] params
  # @option params [String] :phone_number
  # @option params [String] :indicators
  #
  # @return [Hash]
  def execute_request(client, params)
    client.query(
      :elements => { :id => ELEMENT_ID },
      :serviceKeys => {
        :serviceKey => [
          {
            :id    => TELEPHONE_SPECIFICATION_SERVICE_ID,
            :value => params[:phone_number]
          },
          {
            :id    => PHONE_ATTRIBUTES_REQUESTED_SERVICE_ID,
            :value => params[:indicators]
          }
        ]
      }
    )
  end

  # Do element specific processing on response from client.
  #
  # @param [Hash] response
  # @option response [String] :error_code The stringified number
  #                                       of the error code
  # @option response [Hash] :result
  # @param [Hash] params
  # @option params [String] :phone_number
  #
  # @return [Hash]
  def process_response(response, params)
    if response[:error_code] == OUT_OF_DOMAIN_ERROR
      raise OutOfDomainError, params[:phone_number]
    else
      string = response[:result][:element][:value]
      result = {}

      INDICATOR_MAPPINGS.each do |name, mapping|
        mapping.detect do |key, value|
          result[name] = value if string.index(key)
        end
      end

      result
    end
  end

  # Given a list of indicator symbols, derive the argument to send the service.
  #
  # @param [Array<Symbol>] indicators
  # @return [String]
  def parse_indicators(indicators)
    vals =
      if indicators.empty?
        INDICATORS.values
      else
        INDICATORS.values_at(*indicators)
      end

    vals.join(',')
  end
end
