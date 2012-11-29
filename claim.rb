#!/usr/bin/ruby
# encoding: utf-8

class Claim
  PatientModule = '//MmlBody//MmlModuleItem//content//mmlPi:PatientModule'
  def get_personNumber(claim)
    claim.xpath(PatientModule + '//mmlPi:uniqueInfo//mmlPi:masterId//mmlCm:Id').text.strip
  end
  def get_personName(claim)
    claim.xpath(PatientModule + '//mmlPi:personName//mmlNm:Name[@mmlNm:repCode="I"]').text.strip
  end
  def get_personKana(claim)
    claim.xpath(PatientModule + '//mmlPi:personName//mmlNm:Name[@mmlNm:repCode="P"]').text.strip
  end
  def get_personBirthday(claim)
    claim.xpath(PatientModule + '//mmlPi:birthday').text.strip
  end
  def get_personSex(claim)
    personSex = claim.xpath(PatientModule + '//mmlPi:sex').text.strip
    if personSex == "male"
      personSex = "true"
    else
      personSex = "false"
    end
    personSex
  end
end

