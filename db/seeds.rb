# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#User.create!(name:  "アリフ マウラナ",
#             email: "maulanamania@outlook.com",
#             password:              "weluweluwelu",
#             password_confirmation: "weluweluwelu",
#             admin: true,
#             activated: true,
#             activated_at: Time.zone.now)

CompanyType.create!(name: "病院",
                    client: true,
                    flag: 0,
                    user_id: 1)
CompanyType.create!(name: "ベンダー",
                    client: false,
                    flag: 0,
                    user_id: 1)
Company.create!(name: 'NEC',
                address: '静岡市',
                flag: 0,
                company_type_id: 2,
                user_id: 1)
Company.create!(name: '静岡市立病院',
                address: '静岡市',
                flag: 0,
                company_type_id: 1,
                user_id: 1)

if YokyuParent.all.count == 0
  users = User.all
  users.each do |user|
    YokyuParent.create!(name: "仕様書内容", flag: 0, user_id: user.id, default_col: "D", default_set: 1)
    yokyu_parent = YokyuParent.last
    YokyuChild.create!(name: "回答", flag: 0, user_id: user.id, default_col: "E", yokyu_parent_id: yokyu_parent.id)
    YokyuChild.create!(name: "備考", flag: 0, user_id: user.id, default_col: "H", yokyu_parent_id: yokyu_parent.id)
  end
end

#99.times do |n|
#  name  = Faker::Name.name
#  email = "example-#{n+1}@unterlindenunterlinden.org"
#  password = "password"
#  User.create!(name:  name,
#               email: email,
#               password:              password,
#               password_confirmation: password,
#               activated: true,
#               activated_at: Time.zone.now)
#end

# To reset DB
# bluemix cf push -c "bundle exec rake db:migrate:reset" documents
# bluemix cf push -c "null" documents

# To add last user as Admin
# bluemix cf push -f manifest.yml -c "User.last.update_attribute(:admin, true)"