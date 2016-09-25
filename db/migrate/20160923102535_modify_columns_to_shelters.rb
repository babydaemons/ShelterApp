class ModifyColumnsToShelters < ActiveRecord::Migration[5.0]
  def change
    # 緯度経度をdoubleに変更
    latlng = %w(lat lng)
    latlng.each do |column|
      sql = "ALTER TABLE shelters MODIFY COLUMN #{column} double NOT NULL;"
      puts sql
      ActiveRecord::Base.connection.execute(sql)
    end
    # 避難所名・住所をvarchar(128)に変更
    strings = %w(name address)
    strings.each do |column|
      sql = "ALTER TABLE shelters MODIFY COLUMN #{column} varchar(128) NOT NULL;"
      puts sql
      ActiveRecord::Base.connection.execute(sql)
    end
    # 避難所種別をtinyintに変更
    hazards = %w(earthquake_hazard tsunami_hazard wind_and_flood_damage volcanic_hazard)
    hazards.each do |column|
      sql = "ALTER TABLE shelters MODIFY COLUMN #{column} tinyint(1) NOT NULL;"
      puts sql
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
