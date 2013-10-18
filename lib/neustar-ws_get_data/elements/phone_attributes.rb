# From the documentation:
#
# "Element ID 1320 accepts a phone number and returns attributes associated
# with the phone number. Currently, the following attributes are available:
# Prepaid Phone Indicator, Business Phone Indicator (BPI), Phone In-Service
# Indicator, and Phone Type Indicator."
module Neustar::WsGetData::PhoneAttributes
  extend self

  # ID for "Phone Attributes"
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

  # Method used to execute a query against the Phone Attributes element of the
  # WS-GetData Service..
  #
  # @param [Neustar::WsGetData::Client] client
  # @param [#to_s] phone_number
  # @param [Array<Symbol>] indicators
  def query(client, phone_number, indicators = [])
    client.query(
      :elements => { :id => ELEMENT_ID },
      :serviceKeys => {
        :serviceKey => {
          :id    => TELEPHONE_SPECIFICATION_SERVICE_ID,
          :value => phone_number
        }, 
        :serviceKey => {
          :id    => PHONE_ATTRIBUTES_REQUESTED_SERVICE_ID,
          :value => parse_indicators(indicators)
        }
      }
    )
  end

  # Given a list of indicator symbols, derive the argument to send the service.
  #
  # @param [Array<Symbol>] indicators
  # @return String
  def parse_indicators(indicators)
    vals = \
      if indicators.empty?
        INDICATORS.values
      else
        INDICATORS.values_at(indicators)
      end

    vals.join(',')
  end
end 
