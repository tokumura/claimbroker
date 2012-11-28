#!/usr/bin/ruby
# encoding: utf-8

require "socket"
require "rubygems"
require "nokogiri"

require "socket"
require "timeout"

ACK = 0x06.chr
EOT = 0x04.chr

gs = TCPServer.open(12345)

loop do
  Thread.start(gs.accept) do |s|
    puts "accept"
    @doc = ""
    begin
      timeout(5) {
        while s.gets
          @doc << $_
        end
      }
    rescue Timeout::Error
    end
    s.write(ACK)
    puts "gone"
    s.close
    xml = Nokogiri::XML(@doc)
    node = xml.xpath("//MmlBody//MmlModuleItem//content//mmlHi:HealthInsuranceModule//mmlHi:insuranceClass")
    puts node.text



  end
end

