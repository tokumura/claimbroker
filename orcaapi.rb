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
      if hi.xpath('.//string[@name="Insurance_Combination_Number"]').text.strip != ""
        puts hi.xpath('.//string[@name="Insurance_Combination_Number"]').text.strip
        puts hi.xpath('.//string[@name="InsuranceProvider_Class"]').text.strip
        puts hi.xpath('.//string[@name="InsuranceProvider_Number"]').text.strip
        puts hi.xpath('.//string[@name="InsuranceProvider_WholeName"]').text.strip
        puts hi.xpath('.//string[@name="HealthInsuredPerson_Symbol"]').text.strip
        puts hi.xpath('.//string[@name="HealthInsuredPerson_Number"]').text.strip
        puts hi.xpath('.//string[@name="HealthInsuredPerson_Continuation"]').text.strip
        puts hi.xpath('.//string[@name="HealthInsuredPerson_Assistance"]').text.strip
        puts hi.xpath('.//string[@name="RelationToInsuredPerson"]').text.strip
        puts hi.xpath('.//string[@name="HealthInsuredPerson_WholeName"]').text.strip
        puts hi.xpath('.//string[@name="Certificate_StartDate"]').text.strip
        puts hi.xpath('.//string[@name="Certificate_ExpiredDate"]').text.strip
        puts "%%%%%%%%%%%%%%%% next %%%%%%%%%%%%%%%%%"
      end
    end



  end
end
