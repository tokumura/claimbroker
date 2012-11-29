#!/usr/bin/ruby
# encoding: utf-8

class Claimpatient
  def get_patient_module(claim_doc)
    claim = Claim.new()
    xml_claim = Nokogiri::XML(claim_doc)
    @personNumber = claim.get_personNumber(xml_claim)
    @personName = claim.get_personName(xml_claim)
    @personKana = claim.get_personKana(xml_claim)
    @personBirthday = claim.get_personBirthday(xml_claim)
    @personSex = claim.get_personSex(xml_claim)
    
    patient_module = {:number=>@personNumber, 
                      :name=>@personName, 
                      :kana=>@personKana, 
                      :birthday=>@personBirthday, 
                      :sex=>@personSex}
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
