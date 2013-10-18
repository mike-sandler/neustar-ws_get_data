require File.expand_path('./lib/neustar-ws_get_data')

client = Neustar::WsGetData::Client.new('foo', 'bar')
puts client.operations.inspect
client.phone_attributes('2177662402', [:phone_type])
