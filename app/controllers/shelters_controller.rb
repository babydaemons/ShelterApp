class SheltersController < ApplicationController
  DEG_PER_KM = 0.00900005760037

  def home
  end

  def search
    lat = params[:lat].to_f
    lat1 = lat - 5 * DEG_PER_KM
    lat2 = lat + 5 * DEG_PER_KM
    lng = params[:lng].to_f
    deg_per_km = DEG_PER_KM / Math::cos(to_rad(lat))
    lng1 = lng - 5 * deg_per_km
    lng2 = lng + 5 * deg_per_km
    sql = ActiveRecord::Base.send(:sanitize_sql_array,
      ["SELECT * FROM shelters WHERE (lat BETWEEN :lat1 AND :lat2) AND (lng BETWEEN :lng1 AND :lng2) AND (#{hazard_type} > 0)",
        lat1: lat1, lat2: lat2, lng1: lng1, lng2: lng2])
    shelters = ActiveRecord::Base.connection.select_all(sql)
    render :layout => false, :json => shelters.to_json
  end

  private
    def hazard_type
      hazard = 'earthquake_hazard'
      case params[:type].to_i
      when 2
        hazard = 'tsunami_hazard'
      when 3
        hazard = 'wind_and_flood_damage'
      when 4
        hazard = 'volcanic_hazard'
      end
      hazard
    end

    def to_rad(deg)
      deg / 180.0 * Math::PI
    end

    def to_deg(rad)
      rad / Math::PI * 180.0
    end
end
