# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shelter do
    lat 1.5
    lng 1.5
    name "MyString"
    address "MyString"
    earthquake_hazard 1
    tsunami_hazard 1
    wind_and_flood_damage 1
    volcanic_hazard 1
  end
end
