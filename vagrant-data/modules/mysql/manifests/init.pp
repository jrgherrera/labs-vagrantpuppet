class mysql ($user = "root", $password = "", $database = "") {
	package { 'mysql-server' :
		ensure  => 'present',
		require => Exec["apt-get update"],
	}

	service { 'mysql' :
		ensure     => 'running',
		enable     => true,
		hasrestart => true,
		require    => Package["mysql-server"],
		subscribe  => [
			Exec['mysql-changepassword'],
			Exec['mysql-remoteaccess'],
			Exec['mysql-grantpermissions'],
			Exec['mysql-createdatabase'],
			Exec['mysql-importdatabase'],
		],
	}

	exec { 'mysql-changepassword' :
		unless  => "mysqladmin -u${user} -p${password} status",
		command => "mysqladmin -u${user} password ${password}",
		require => Package["mysql-server"],
	}

	exec { 'mysql-remoteaccess' :
		command => 'sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf',
		require => Package["mysql-server"],
	}

	exec { 'mysql-grantpermissions' :
		command => "mysql -u${user} -p${password} < \"/vagrant/vagrant-data/modules/mysql/files/enable-remote-access.sql\"",
		require => [
			Package["mysql-server"],
			File["file-mysql-grantpermissions"],
		],
	}

	exec { 'mysql-createdatabase' :
		command => "mysql -u${user} -p${password} -e \"CREATE DATABASE IF NOT EXISTS ${database};\"",
		require => [
			Package["mysql-server"],
			Exec["mysql-changepassword"],
		],
	}

	exec { 'mysql-importdatabase' :
		command => "mysql -u${user} -p${password} ${database} < \"/vagrant/vagrant-data/modules/mysql/files/backup.sql\"",
		onlyif	=> "test -f /vagrant/vagrant-data/modules/mysql/files/backup.sql",
		require => [
			Package["mysql-server"],
			Exec["mysql-changepassword"],
		],
	}

	file { 'file-mysql-grantpermissions' :
		path => '/vagrant/vagrant-data/modules/mysql/files/enable-remote-access.sql',
		content => "GRANT USAGE ON *.* TO '${user}'@'%'; DROP USER '${user}'@'%'; FLUSH PRIVILEGES; CREATE USER '${user}'@'%' IDENTIFIED BY '${password}'; GRANT ALL PRIVILEGES ON * . * TO '${user}'@'%' WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;",
	}

    notify { "MySQL installation: Done!" : 
    	loglevel => 'info',
    	require  => Service["mysql"],
    }
}