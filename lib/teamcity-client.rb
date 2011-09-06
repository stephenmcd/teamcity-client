require "rubygems"
require "rest-client"
require "nokogiri"

# Team City HTTP client.
#
# Authentication is not yet supported and therefore guest access is
# required.
#
# Currently supports retrieving the number of new build errors for
# a given build.
#
# Initialize with a host:port string for grabbing and parsing pages
# in the Team City interface.
class TeamCityClient

  VERSION = "0.0.2"

  def initialize(host)
    @host = host
  end

  def build_errors(build_id, show_progress=true)
    # Grab the build page for the given build ID and parse the page
    # for amount of time left for the build to complete. Keep hitting
    # the page until the build is complete and output the amout of time
    # remaining. Once the build is complete, parse the page for any
    # new errors and return the number.
    begin
      html = RestClient.get("http://#{@host}/viewLog.html?buildId=#{build_id}&guest=1")
      doc = Nokogiri::HTML(html)
      parts = doc.css(".statusTable").text.split("Time left:")
      time_left = parts.length > 1 ? parts[1].split("(")[0].gsub(/\s+/, "") : ""
      if show_progress && !time_left.empty?
        STDOUT.write "\rTime left: #{time_left} (CTRL-C to abort)"
        STDOUT.flush
      end
      sleep 1
    end until time_left.empty?
    doc.css(".failCount strong").text.to_i
  end

end
