#!/usr/bin/ruby
# encoding: utf-8

require "rubygems"
require "nokogiri"
require "rest_client"
require "socket"
require "timeout"
require "./claimpatient.rb"
require "./claiminsurance.rb"
require "./claim.rb"
require "./orcaapi.rb"

ACK = 0x06.chr
TRITON_HOST = "http://127.0.0.1:3000"
STREAM_TIMEOUT = 3

puts "server start!"
socketserver = TCPServer.open(12345)

=begin
if Process.respond_to? :daemon
  # Ruby 1.9
  Process.daemon
else
  # Ruby 1.8
  require 'webrick'
  WEBrick::Daemon.start
end
=end

loop do
  Thread.start(socketserver.accept) do |stream|

    puts "accept"
    @claim_doc = ""
    @exist = false

    begin
      timeout(STREAM_TIMEOUT) {
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

    orcaapi = Orcaapi.new()
    @insurance_module_list = orcaapi.get_patient_info(@patient_module[:number].to_s)

    # Request to TRITON
    @exist_ptId = claimpatient.check_exist(TRITON_HOST, @patient_module)
    if @exist_ptId == ""
      puts "create new patient"
      puts @insurance_module_list
      RestClient.post(TRITON_HOST + "/patients.xml", :patient => @patient_module, 'insurances[]' => @insurance_module_list)
    else
      puts "update patient id : " + @exist_ptId
      RestClient.put(TRITON_HOST + "/patients/#{@exist_ptId}.xml", :patient => @patient_module, 'insurances[]' => @insurance_module_list)
    end

  end
end
