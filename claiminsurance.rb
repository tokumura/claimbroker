#!/usr/bin/ruby
# encoding: utf-8

class Claiminsurance
  def get_insurance_module(claim_doc)
    claim = Claim.new()
    xml_claim = Nokogiri::XML(claim_doc)
    insurance_module_list = Array.new()

    puts "######################0"

    xml_claim.xpath('//Mml//MmlBody//MmlModuleItem//content//mmlHi:HealthInsuranceModule').each do |ins|

      puts "######################1"

      # 主保険情報
      insurance_class = ins.xpath('.//mmlHi:insuranceClass').text.strip
      insurance_number = ins.xpath('.//mmlHi:insuranceNumber').text.strip
      client_group = ins.xpath('.//mmlHi:clientId//mmlHi:group').text.strip
      client_number = ins.xpath('.//mmlHi:clientId//mmlHi:number').text.strip
      family_class = ins.xpath('.//mmlHi:familyClass').text.strip
      start_date = ins.xpath('.//mmlHi:startDate').text.strip
      expired_date = ins.xpath('.//mmlHi:expiredDate').text.strip
      payment_out_ratio = ins.xpath('.//mmlHi:paymentOutRatio').text.strip
      
      # 公費情報
      public_insurance_module_list = Array.new()
      ins.xpath('.//mmlHi:publicInsurance//mmlHi:publicInsuranceItem').each do |pub|
        public_insurance_module = {:provider_name => pub.xpath('.//mmlHi:providerName').text.strip,
                                   :provider => pub.xpath('.//mmlHi:provider').text.strip,
                                   :recipient => pub.xpath('.//mmlHi:recipient').text.strip,
                                   :start_date => pub.xpath('.//mmlHi:startDate').text.strip,
                                   :expired_date => pub.xpath('.//mmlHi:expiredDate').text.strip,
                                   :payment_ratio => pub.xpath('.//mmlHi:paymentRatio').text.strip}

        public_insurance_module_list << public_insurance_module
      end

      insurance_module = {:insurance_class => insurance_class, 
                         :insurance_number => insurance_number,
                         :client_group => client_group,
                         :client_number => client_number,
                         :family_class => family_class,
                         :start_date => start_date,
                         :expired_date => expired_date,
                         :payment_out_ratio => payment_out_ratio,
                         :public_insurance_list => public_insurance_module_list}

      puts insurance_module
      insurance_module_list << insurance_module
      puts "######################2"
    end
    puts insurance_module_list
    puts "######################3"
    
  end

  def check_exist(triton_host, ptmod)
    xml_patients = Nokogiri::XML(RestClient.get(triton_host + "/patients.xml"))
    xml_patients.xpath('.//patients//patient').each do |pt|
      kana = pt.xpath('.//kana').text.strip
      birthday = pt.xpath('.//birthday').text.strip
      sex = pt.xpath('.//sex').text.strip

      puts ptmod[:kana] + "/" + ptmod[:birthday] + "/" + ptmod[:sex]
      puts kana + "/" + birthday + "/" + sex

      @exist_ptId = ""
      if ptmod[:kana] == kana && ptmod[:birthday] == birthday && ptmod[:sex] == sex
        @exist_ptId = pt.xpath('.//id').text.strip
      end
      break if @exist_ptId != ""
    end
    @exist_ptId
  end
end
