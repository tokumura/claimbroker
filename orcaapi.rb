#!/usr/bin/ruby
#lthInsuredPerson_Number encoding: utf-8

require "rubygems"
require "nokogiri"
require "rest_client"
require 'open-uri'

class Orcaapi
  ORCA_HOST = "192.168.0.187:8000"
  ORCA_USER = "ormaster"
  ORCA_PASS = "ormaster"
  API_URL = 'http://' + ORCA_USER + ":" + ORCA_PASS + "@" + ORCA_HOST + "/api01r/patientget?id="

  def get_patient_info(ptId)
    patient_info = Nokogiri::XML(RestClient.get(API_URL + ptId))
    patient_info.xpath('.//data//record//record//array//record').each do |hi|
      if hi.xpath('./string[@name="Insurance_Combination_Number"]').text.strip != ""
        # 主保険
        insurance_module = {:combination_number => hi.xpath('./string[@name="Insurance_Combination_Number"]').text.strip,
                            :provider_class => hi.xpath('./string[@name="InsuranceProvider_Class"]').text.strip,
                            :provider_number => hi.xpath('./string[@name="InsuranceProvider_Number"]').text.strip,
                            :provider_wholename => hi.xpath('./string[@name="InsuranceProvider_WholeName"]').text.strip,
                            :person_symbol => hi.xpath('./string[@name="HealthInsuredPerson_Symbol"]').text.strip,
                            :person_number => hi.xpath('./string[@name="HealthInsuredPerson_Number"]').text.strip,
                            :person_continuation => hi.xpath('./string[@name="HealthInsuredPerson_Continuation"]').text.strip,
                            :person_assistancd => hi.xpath('./string[@name="HealthInsuredPerson_Assistance"]').text.strip,
                            :relation_to_insured_person => hi.xpath('./string[@name="RelationToInsuredPerson"]').text.strip,
                            :person_wholename => hi.xpath('./string[@name="HealthInsuredPerson_WholeName"]').text.strip,
                            :certificate_startdate => hi.xpath('./string[@name="Certificate_StartDate"]').text.strip,
                            :certificate_expiredate => hi.xpath('./string[@name="Certificate_ExpiredDate"]').text.strip}
                            #:public_list => public_module_list}
        # 公費
        public_module_list = Array.new()
        hi.xpath('.//array//record').each do |pb|
          if pb.xpath('.//string[@name="PublicInsurance_Class"]').text.strip != ""
            puts "###"
            public_module = {:class => pb.xpath('./string[@name="PublicInsurance_Class"]').text.strip,
                             :name => pb.xpath('./string[@name="PublicInsurance_Name"]').text.strip,
                             :insurer_number => pb.xpath('./string[@name="PublicInsurer_Number"]').text.strip,
                             :person_number => pb.xpath('./string[@name="PublicInsuredPerson_Number"]').text.strip,
                             :rate_admission => pb.xpath('./string[@name="Rate_Admission"]').text.strip,
                             :money_admission => pb.xpath('./string[@name="Money_Admission"]').text.strip,
                             :rate_outpatient => pb.xpath('./string[@name="Rate_Outpatient"]').text.strip,
                             :money_outpatient => pb.xpath('./string[@name="Money_Outpatient"]').text.strip,
                             :certificate_issuedate => pb.xpath('./string[@name="Certificate_IssuedDate"]').text.strip,
                             :certificate_expiredate => pb.xpath('./string[@name="Certificate_ExpiredDate"]').text.strip}
            public_module_list << public_module
          end
        end

        insurance_module.store(:public_list, public_module_list)
        puts insurance_module
        puts "%%%%%%%%%%%%%%%% next %%%%%%%%%%%%%%%%%"
      end
    end
    insurance_module
  end
end
