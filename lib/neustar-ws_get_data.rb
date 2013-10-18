require 'savon'

# Toplevel namespace
module Neustar
  # Wrapper to interface with the WS-GetData Service
  module WsGetData
    # Location of SOAP WSDL for WS-GetData
    WSDL = 'http://webapp.targusinfo.com/ws-getdata/query.asmx?WSDL'
  end

  # Top-level error class for Neustar
  class Error < StandardError
  end
end

require File.expand_path("../neustar-ws_get_data/version", __FILE__)
require File.expand_path("../neustar-ws_get_data/client", __FILE__)

elements = File.expand_path("../neustar-ws_get_data/elements/*", __FILE__)
Dir[elements].each {|element| require element }
