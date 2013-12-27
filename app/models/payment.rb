require 'net/http'
require 'uri'
class Payment < ActiveRecord::Base
  attr_accessor :cardNumber, :cardCVV, :cardExpiryMonth, :cardExpiryYear
    
  attr_accessible :responseMessage, :amount, :amountReceived, :cardNumberMask,
  :cardType, :cardTypeCode, :responseCode, :transactionID, :xref, :cardNumber,
  :cardCVV, :cardExpiryMonth, :cardExpiryYear

  validate :credit_card_api_access, :on => :create
  MERCHANT_ID = "100001"
  INTEGRATION_URL = "https://gateway.cardstream.com/direct/"
   PRE_SHARED_KEY = 'Circle4Take40Idea'

  def request_data
    { 
      :merchantID => MERCHANT_ID,
      :action => "SALE", 
      :type => 1,
      :currencyCode => 826,
      :countryCode => 826,
      :amount => self.amount.to_i,
      :cardNumber => self.cardNumber,
      :cardExpiryMonth => self.cardExpiryMonth.to_i,
      :cardExpiryYear => self.cardExpiryYear.to_i,
      :cardCVV => self.cardCVV.to_i,
      :orderRef => "Test purchase",
      :returnInternalData => "Y",
      :threeDSRequired => "N",
    }
  end



  def credit_card_api_access
    uri = URI.parse(INTEGRATION_URL)
    http = Net::HTTP.new(uri.host, 443)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri)
    req.set_form_data(request_data,PRE_SHARED_KEY)
    response = http.request(req)
    response_hash = Rack::Utils.parse_nested_query response.body
    if response_hash['responseCode'] != "0"
      errors.add(:id, "Payment failed #{response_hash['responseMessage']}")
    else
      self.attributes = strip_cc_response_hash(response_hash)
    end
  end

    def strip_cc_response_hash(hsh)
       hsh.each { |key,value| hsh.delete(key) unless Payment.column_names.include?(key)}
       return hsh
    end

end
