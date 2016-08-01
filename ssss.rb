name = 'railsss'
pass = 'railsss'
database = 'railsss'
user_exist =  %x( mysql -u root -e "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '#{name}');" )

if user_exist.split("\n")[1] == '0'
	# %x( mysql -u root -e "INSERT INTO mysql.user(Host,User,Password) values('localhost','#{name}',password('#{pass}'));flush privileges;" )
end
%x( mysql -u #{name} -p#{pass} -e "create database #{database}; GRANT ALL PRIVILEGES ON #{database}.* TO #{name}@localhost IDENTIFIED BY '#{pass}';")