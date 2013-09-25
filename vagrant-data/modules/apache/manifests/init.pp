class apache ($servername = "") {
	$packages = [
		"apache2",
		"libapache2-mod-php5",
	]

	package { $packages :
		ensure  => 'present',
		require => [
			Exec["apt-get update"],
			Notify["php"],
		],
	}

	service { 'apache2' :
		ensure     => 'running',
		enable     => true,
		hasrestart => true,
		restart	   => "sudo service apache2 restart",
		require    => [
			Package["apache2"],
			Package["php5"], #ensure that php has been installed before restart
		],
		subscribe  => [
			File['apache-virtualhosts'],
			File['apache-modrewrite'],
			Exec["remove-index"],
			Exec["upload-max-filesize"],
			Exec["set-phpini-timezone"],
		],
	}

	file { 'apache-virtualhosts' :
		path    => '/etc/apache2/sites-enabled/000-default.conf',
		source  => '/vagrant/vagrant-data/modules/apache/files/apache-virtualhosts',
		require => Package['apache2'],
	}

	file { 'apache-configuration' :
		path    => '/etc/apache2/apache2.conf',
		source  => '/vagrant/vagrant-data/modules/apache/files/apache-configuration',
		require => Package['apache2'],
	}

	file { 'apache-modrewrite' :
		path    => '/etc/apache2/mods-enabled/rewrite.load',
		ensure	=> 'link',
		target  => '/etc/apache2/mods-available/rewrite.load',
		require => Package['apache2'],
	}

	exec { 'remove-index' :
		command => "rm /var/www/index.html",
		onlyif	=> "test -f /var/www/index.html",
		require => Package["apache2"],
	}

	exec { 'upload-max-filesize' :
		command => 'sudo sed -i "s/^upload_max_filesize = 2M/upload_max_filesize = 32M/" /etc/php5/apache2/php.ini',
		require => Package["apache2"],
	}

	exec { 'set-phpini-timezone' :
		command => 'sudo sed -i "s/^;date.timezone =/date.timezone = America\/Chicago/" /etc/php5/apache2/php.ini',
		require => Package["apache2"],
	}

    notify { "apache" : 
    	message  => "Apache installation: Done!",
    	loglevel => 'notice',
    	require  => Service["apache2"],
    }
}