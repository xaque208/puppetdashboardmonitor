require "net/http"
require "uri"

module PuppetDashboardMonitoring
  module_function

  def go (config)
    @config = config
    data = Hash.new
    data[:nodes] = Hash.new
    data[:nodes][:total]        = get_json("#{@config[:url]}/nodes.json").count
    data[:nodes][:changed]      = get_json("#{@config[:url]}/nodes/changed.json").count
    data[:nodes][:unresponsive] = get_json("#{@config[:url]}/nodes/unresponsive.json").count
    data[:nodes][:failed]       = get_json("#{@config[:url]}/nodes/failed.json").count
    data[:nodes][:pending]      = get_json("#{@config[:url]}/nodes/pending.json").count
    data
  end

  def get_json (url, user=@config[:authuser], pass=@config[:authpass])
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    #http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(user,pass)
    response = http.request(request)
    JSON.parse(response.body)
  end

end
