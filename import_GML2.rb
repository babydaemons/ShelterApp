#!/usr/bin/env ruby

require 'rexml/document'
include REXML

class GML
  @@positions = {}
  @@file = File::open('shelters.csv', 'w:utf-8')

  def initialize(path)
    path =~ /P20-12_([0-9]{2})\.xml$/
    @pref_cd = (100 + $1.to_i) * 1000000
    f = open(path)
    xml = f.read
    f.close
    @doc = Document.new xml
  end

  def get_positions
    @link_list = []
    @id_list = []
    XPath.each(@doc, '/ksj:Dataset/gml:Point/@gml:id') {|link|
      @link_list << link.to_s
      link.to_s =~ /pt([0-9]+)/
      @id_list << @pref_cd + $1.to_i
    }
    @lat_list = []
    @lng_list = []
    XPath.each(@doc, '/ksj:Dataset/gml:Point/gml:pos/text()') {|latlng|
      coordinates = latlng.to_s.split(/ /)
      @lat_list << coordinates[0].to_f
      @lng_list << coordinates[1].to_f
    }
    @id_list.count.times {|i|
      @@positions[@id_list[i]] = { :lat => @lat_list[i], :lng => @lng_list[i] }
    }
  end

  def get_details
    @name_list = []
    XPath.each(@doc, '/ksj:Dataset/ksj:EvacuationFacilities/ksj:name/text()') {|name| @name_list << name.to_s.chomp }
    @address_list = []
    XPath.each(@doc, '/ksj:Dataset/ksj:EvacuationFacilities/ksj:address/text()') {|address| @address_list << address.to_s.chomp }
    @not_specified_list = []
    XPath.each(@doc, '/ksj:Dataset/ksj:EvacuationFacilities/ksj:hazardClassification/ksj:Classification/ksj:notSpecified/text()') {|not_specified|
      @not_specified_list << not_specified.to_s == 'true'
    }
    earthquake_hazard_list = []
    get_hazards(earthquake_hazard_list, 'earthquakeHazard')
    tsunami_hazard_list = []
    get_hazards(tsunami_hazard_list, 'tsunamiHazard')
    wind_and_flood_damage_list = []
    get_hazards(wind_and_flood_damage_list, 'windAndFloodDamage')
    volcanic_hazard_list = []
    get_hazards(volcanic_hazard_list, 'volcanicHazard')

    @id_list.count.times {|i|
      @@file.puts "#{@id_list[i]},#{@lat_list[i]},#{@lng_list[i]},#{@name_list[i]},#{@address_list[i]}," +
                  "#{earthquake_hazard_list[i]},#{tsunami_hazard_list[i]},#{wind_and_flood_damage_list[i]},#{volcanic_hazard_list[i]}" unless @id_list[i].nil?
    }
  end

  def get_hazards(list, hazard_name)
    i = 0
    XPath.each(@doc, "/ksj:Dataset/ksj:EvacuationFacilities/ksj:hazardClassification/ksj:Classification/ksj:#{hazard_name}/text()") {|node|
      list << ((node.to_s == 'true') ? 2 : (@not_specified_list[i] ? 1 : 0))
      i += 1
    }
  end
end

ARGV.each {|path|
  puts "parsing #{path}..."
  gml = GML.new path
  gml.get_positions
  gml.get_details
}
