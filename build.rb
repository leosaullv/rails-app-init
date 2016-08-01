def say_custom(tag, text); say "\033[1m\033[36m" + tag.to_s.rjust(10) + "\033[0m" + "  #{text}" end
def say_loud(tag, text); say "\033[1m\033[36m" + tag.to_s.rjust(10) + "  #{text}" + "\033[0m" end
def say_recipe(name); say "\033[1m\033[36m" + "recipe".rjust(10) + "\033[0m" + "  Running #{name} recipe..." end
def say_wizard(text); say_custom('composer', text) end

def ask_wizard(question)
  ask "\033[1m\033[36m" + ("option").rjust(10) + "\033[1m\033[36m" + "  #{question}\033[0m"
end

def whisper_ask_wizard(question)
  ask "\033[1m\033[36m" + ("choose").rjust(10) + "\033[0m" + "  #{question}"
end

def yes_wizard?(question)
  answer = ask_wizard(question + " \033[33m(y/n)\033[0m")
  case answer.downcase
    when "yes", "y"
      true
    when "no", "n"
      false
    else
      yes_wizard?(question)
  end
end

def no_wizard?(question); !yes_wizard?(question) end

def multiple_choice(question, choices)
  say_custom('option', "\033[1m\033[36m" + "#{question}\033[0m")
  values = {}
  choices.each_with_index do |choice,i|
    values[(i + 1).to_s] = choice[1]
    say_custom( (i + 1).to_s + ')', choice[0] )
  end
  answer = whisper_ask_wizard("Enter your selection:") while !values.keys.include?(answer)
  values[answer]
end

def get_remote(src, dest = nil)
  dest ||= src
  repo = '~/agan/rails-app-init/files/'
  remote_file = repo + src
  remove_file dest
  get(remote_file, dest)
end


# *******Applicaton config*******../
say 'Application config...'
inject_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<-EOF
    config.time_zone = 'Beijing'
    config.i18n.default_locale = "zh-CN"
    config.autoload_paths += %W(\#{Rails.root}/lib)
    config.generators do |g|
      g.orm             :active_record
      g.assets            false
      g.helper            true
      g.jbuilder          false
      g.test_framework :rspec,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
EOF
end

inject_into_file 'config/environments/development.rb', after: "Rails.application.configure do\n" do <<-EOF
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'address',
    port: 'xxx',
    domain: 'domain',
    user_name: 'username',
    password: 'password',
    authentication: 'plain',
    enable_starttls_auto: true,
    ssl: true,
    tls: true
  }
EOF
end

inject_into_file 'config/environments/production.rb', after: "Rails.application.configure do\n" do <<-EOF
  config.action_mailer.default_url_options = { host: 'xxx.com' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'address',
    port: 'xxx',
    domain: 'domain',
    user_name: 'username',
    password: 'password',
    authentication: 'plain',
    enable_starttls_auto: true,
    ssl: true,
    tls: true
  }
EOF
end
get_remote('config/gitignore', '.gitignore')
get_remote('locales/zh-CN.yml', 'config/locales/zh-CN.yml')
get_remote('config/settings.yml', 'config/settings.yml')
gsub_file "Gemfile", /source 'https:\/\/rubygems.org'/, "source 'https://gems.ruby-china.org'"
# *******Applicaton config*******..end/

# *******Bootstrap config*******../
say 'Bootstrap config...'
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
after_bundle do
  run 'bundle exec rails g bootstrap:install static'
end
# *******Bootstrap config*******..end/


# *******Database Config*******../
# database = multiple_choice "Database selected?", [["Mysql", "mysql2"],["Postgresql", "pg"]] 
# case database
#   when 'pg'
#     # say_wizard "Postgresql config..."
#     # name = whisper_ask_wizard("Enter your postgresql username:")
#     # pass = whisper_ask_wizard("Enter your postgresql password:")
#     # database = whisper_ask_wizard("Enter your database name which will be created:")
#     # user_exist = %x( psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='#{name}'" )
#     # if user_exist != '1'
#     #   %x( psql -c "CREATE USER #{name} WITH PASSWORD '#{pass}';" )
#     # end
#     # %x( mysql -u root -e "create database #{database}; GRANT ALL PRIVILEGES ON #{database}.* TO #{name}@localhost IDENTIFIED BY '#{pass}';")
    
#   when 'mysql2'
#     say_wizard "Mysql config..."
#     name = whisper_ask_wizard("Enter your mysql username:")
#     pass = whisper_ask_wizard("Enter your mysql password:")
#     database = whisper_ask_wizard("Enter your database name which will create:")
#     user_exist = %x( mysql -u root -e "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '#{name}');" )
#     if user_exist.split("\n")[1] == '0'
#     	%x( mysql -u root -e "GRANT USAGE ON *.* TO '#{name}'@'localhost' IDENTIFIED BY '#{pass}' WITH GRANT OPTION;;flush privileges;" )
#     end
#     %x( mysql -u root -e "create database #{database}; GRANT ALL PRIVILEGES ON #{database}.* TO #{name}@localhost IDENTIFIED BY '#{pass}';")
#     inject_into_file 'Gemfile', after: "source https://gems.ruby-china.org\n" do <<-EOF
#         gem 'mysql2'
#     EOF
#     gem 'mysql2'
#   end
# get_remote('config/database.#{database}.yml.example', 'config/database.yml')

# gsub_file "config/database.yml", /_name/, name
# gsub_file "config/database.yml", /_pass/, pass
# gsub_file "config/database.yml", /_database/, database

# *******Database Config*******..end/


# *******Rspec config*******../
say 'Rspec config...'
gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
end
gem_group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'email_spec'
  gem 'rails-controller-testing'
end
after_bundle do
  run 'bundle exec rails g rspec:install'
end
get_remote('rspec/support/capybara.rb', 'spec/support/capybara.rb')
get_remote('rspec/support/capybara_driver_resolver.rb', 'spec/support/capybara_driver_resolver.rb')
get_remote('rspec/support/database_cleaner.rb', 'spec/support/database_cleaner.rb')
get_remote('rspec/support/email_spec.rb', 'spec/support/email_spec.rb')
get_remote('rspec/support/factory_girl.rb', 'spec/support/factory_girl.rb')

# *******Rspec config*******..end/

# *******Simple Form config*******../

if yes_wizard? "Add Simple Form?"
  say_wizard "install and config simple_form gem"
  gem 'simple_form'
  after_bundle do
    run 'bundle exec rails g simple_form:install --bootstrap'
  end
end
# *******Simple Form config*******..end/

# *******Devise config*******../

if yes_wizard? "Add Devise?"
  say_wizard "install and config devise gem"
  gem 'devise'
  get_remote('locales/devise.zh-CN.yml', 'config/locales/devise.zh-CN.yml')
  after_bundle do
    run 'bundle exec rails g devise:install'
    run 'bundle exec rails g devise User'
    run 'bundle exec rails g devise:views'
  end
end
# *******Devise config*******..end/

# *******YunPian SMS config*******../
if yes_wizard? 'Add ChinaSms(default YunPian)?'
  say_wizard 'install and config ChinaSms gem'
  get_remote('lib/sms_service/yunpian.rb', 'lib/sms_service/yunpian.rb')
  get_remote('lib/sms_service/send_sms.rb', 'lib/sms_service/send_sms.rb')
  gem 'china_sms'
  inject_into_file 'config/settings.yml', after: '' do <<-EOF
sms_service: 'yunpian'
EOF
end
end

# *******YunPian SMS config*******..end/

# *******WillPaginate OR Kaminari config*******../
paginate = multiple_choice "Pagination selected?", [["will_paginate", "will_paginate"],["kaminari", "kaminari"]] 
say_wizard "install and config #{paginate} gem"
case paginate
  when 'will_paginate'
    gem 'will_paginate-bootstrap'
  when 'kaminari'
    gem 'kaminari'
  end
# *******WillPaginate OR Kaminari config*******..end/
# *******ActiveAdmin config*******../
if yes_wizard? 'Add ActiveAdmin?'
  say_wizard 'install and config ActiveAdmin'
  gem 'activeadmin', github: 'activeadmin'
  after_bundle do
    run 'bundle exec rails g active_admin:install'
  end
  if paginate == 'will_paginate'
    get_remote('config/kaminari.rb', 'config/initializers/kaminari.rb' )
  end
end
# *******ActiveAdmin config*******..end/


# *******QiNiuYun config*******../

# *******QiNiuYun config*******..end/




# *******Applicaton config*******../

# *******Applicaton config*******..end/

