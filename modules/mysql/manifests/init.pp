class mysql ($password = "") {
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
		],
	}

	exec { 'mysql-changepassword' :
		unless  => "mysqladmin -uroot -p${password} status",
		command => "mysqladmin -uroot password ${password}",
		require => Package["mysql-server"],
	}

	exec { 'mysql-remoteaccess' :
		command => 'sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf',
		require => Package["mysql-server"],
	}

	exec { 'mysql-grantpermissions' :
		command => "mysql -uroot -p${password} < \"/vagrant/modules/mysql/files/enable-remote-access.sql\"",
		require => [
			Package["mysql-server"],
			File["file-mysql-grantpermissions"],
		],
	}

	file { 'file-mysql-grantpermissions' :
		path => '/vagrant/modules/mysql/files/enable-remote-access.sql',
		content => "CREATE USER 'root'@'%' IDENTIFIED BY '${password}'; GRANT ALL PRIVILEGES ON * . * TO 'root'@'%' WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;",
	}
}