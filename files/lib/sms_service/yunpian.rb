class SMSService::Yunpian

  def self.to(phone_number, sms_message)
    ChinaSMS.use :yunpian, password: ENV["YUNPIAN_PASSWORD"]
    ChinaSMS.to phone_number, sms_message
  end
end
