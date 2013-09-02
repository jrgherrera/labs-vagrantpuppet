class php {
	$packages = [
		"php5",
		"php5-cli",
		"php5-curl",
		"php5-dev",
		"php5-gd",
		"php5-geoip",
		"php5-mcrypt",
		"php5-mysql",
		"php5-uuid",
		"libapache2-mod-php5",
	]

	package { $packages :
		ensure  => 'present',
		require => Exec["apt-get update"],
	}

	file { 'php-phpinfo' :
		path    => '/var/www/info.php',
		source  => '/vagrant/vagrant-data/modules/php/files/info.php',
		require => Package['php5'],
	}

    notify { "PHP installation: Done!" : 
    	loglevel => 'notice',
    	require  => Package["php5"],
    }
}