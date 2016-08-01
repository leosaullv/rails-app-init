class SMSService::SendSMS

  def self.to(phone_number, sms_message)
  	puts 'send message.............'
    service_impl.to phone_number, sms_message 
  end

  def self.service_impl
    sms_service = SMSService.const_get(Settings.sms_service.camelcase)
  end
end
