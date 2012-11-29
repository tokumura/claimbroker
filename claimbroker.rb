#!/usr/bin/ruby
# encoding: utf-8

require "rubygems"
require "nokogiri"
require "rest_client"
require "socket"
require "timeout"
require "./claimpatient.rb"
require "./claim.rb"

ACK = 0x06.chr
TRITON_HOST = "http://127.0.0.1:3000"

puts "server start!"
socketserver = TCPServer.open(12345)

loop do
  Thread.start(socketserver.accept) do |stream|

    puts "accept"
    @claim_doc = ""
    @exist = false

    begin
      timeout(3) {
        while stream.gets
          @claim_doc << $_
        end
      }
    rescue Timeout::Error
    end

    stream.write(ACK)
    puts "send ACK to client."
    stream.close

    claimpatient = Claimpatient.new()
    @patient_module = claimpatient.get_patient_module(@claim_doc)
    @exist_ptId = claimpatient.check_exist(TRITON_HOST, @patient_module)

    if @exist_ptId == ""
      puts "create new patient"
      RestClient.post(TRITON_HOST + "/patients.xml", :patient => @patient_module)
    else
      puts "update patient id : " + exist_ptId
      RestClient.put(TRITON_HOST + "/patients/#{@exist_ptId}.xml", :patient => @patient_module,
                                                    :insurance => {:combination_number=>'06138721', 
                                                                   :provider_name=>'組合'})
    end
  end
end
