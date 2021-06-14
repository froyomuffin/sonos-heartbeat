require 'savon'

class SonosClient
  PORT = 1400
  NAMESPACE = 'http://www.sonos.com/Services/1.1'
  TRANSPORT_ENDPOINT = '/MediaRenderer/AVTransport/Control'
  TRANSPORT_XMLNS = 'urn:schemas-upnp-org:service:AVTransport:1'
  
  ENV_IP_NAME = 'FROYOMUFFIN_SONOS_IP'

  def initialize
    ip = ENV[ENV_IP_NAME]

    raise "No IP found in ENV[#{ENV_IP_NAME}]" if ip.nil?

    @client ||= Savon.client(
      endpoint: "http://#{ip}:#{PORT}#{TRANSPORT_ENDPOINT}",
      namespace: NAMESPACE, 
      log: false
    )
  end

  def play
    send("Play")
  end

  def pause
    send("Pause")
  end

  private

  def send(name)
    action = "#{TRANSPORT_XMLNS}##{name}"
    message = %Q{<u:#{name} xmlns:u="#{TRANSPORT_XMLNS}"><InstanceID>0</InstanceID><Speed>1</Speed></u:#{action}>}
    @client.call(name, soap_action: action, message: message)
  end
end

sonos = SonosClient.new

loop do
  puts "Sending play"
  sonos.play
  sleep 10
end

