# http://t11a.hatenablog.com/entry/2013/03/06/193731
csv_file = "shelters.csv"
sql = "LOAD DATA LOCAL INFILE '#{csv_file}' INTO TABLE shelters FIELDS TERMINATED BY ','  LINES TERMINATED BY '\\n'"
puts sql
ActiveRecord::Base.connection.execute(sql)
