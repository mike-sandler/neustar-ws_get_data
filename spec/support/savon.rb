module SavonSupport
  def soap_fault(name)
    Savon::SOAPFault.new(new_response(:body => load_fixture(name)), nori)
  end

  def load_fixture(name)
    File.read(File.expand_path("../../fixtures/#{name}", __FILE__))
  end

  def new_response(options = {})
    defaults = { :code => 500, :headers => {}, :body => '' }
    response = defaults.merge options

    HTTPI::Response.new response[:code], response[:headers], response[:body]
  end

  def nori
    Nori.new( :strip_namespaces => true,
              :convert_tags_to  => lambda { |tag| tag.snakecase.to_sym } )
  end
end

RSpec.configure do |config|
  config.include(SavonSupport)
end
