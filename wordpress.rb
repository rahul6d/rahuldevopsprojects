execute "apt update" do
command "apt-get update"
end
packages = ['apache2', 'mysql-server', 'mysql-client', 'php', 'libapache2-mod-php', 'php-mcrypt', 'php-mysql', 'unzip']
packages.each do |package|
 apt_package package do
   action :install
 end
service "apache2" do
action :start
end
execute "mysqladmin" do
command "mysqladmin -u root password root"
end
remote_file "mysqlcommands" do
    source 'https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/mysqlcommands'
    path "/tmp/mysqlcommands"
end
execute "command" do
command "mysql -uroot -proot < /tmp/mysqlcommands"
end
remote_file "latest" do
    source 'https://wordpress.org/latest.zip'
    path "/tmp/latest.zip"
end
execute "unzip" do
  command "unzip /tmp/latest.zip -d /var/www/html"
end
remote_file "wp-config-sample" do
    source 'https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/wp-config-sample.php'
    path "/var/www/html/wordpress/wp-config-sample.php"
end
file '/var/www/html/wordpress' do  
mode '755'
  owner 'root'
end
execute "apache2" do
command "service apache2 restart"
end
end