class php ($repository = "") {

	$packages = [
		"php5",
	]

	$extensions = [
        "php5-apcu",
		"php5-cli",
		"php5-curl",
		"php5-dev",
		"php5-gd",
		"php5-geoip",
		"php5-intl",
		"php5-mcrypt",
		"php5-mysql",
		"php-pear",
	]

	exec { "update-repo" :
		command => "apt-get update"
	}

	exec { "add-new-repository" :
		command => "add-apt-repository ${repository}",
		require => Package["python-software-properties"],
	}

	package { $packages :
		ensure    => 'present',
		require   => [
			Exec["add-new-repository"],
			Exec["update-repo"],
		],
	}

	package { $extensions :
		ensure    => 'present',
		require   => [
			Package[$packages],
		],
	}

	exec { 'enable-rfc1867':
		command => 'sudo -- sh -c \'echo "apc.rfc1867 = 1" >> /etc/php5/mods-available/apcu.ini\'',
		require => [
			Package[$packages],
			Package[$extensions],
		],
	}

	file { 'php-phpinfo' :
		path    => '/var/www/info.php',
		source  => '/vagrant/vagrant-data/modules/php/files/info.php',
		require => [
			Package[$packages],
			Package[$extensions],
		],
	}

    notify { "php" : 
    	message  => "PHP installation: Done!",
    	loglevel => 'notice',
		require => [
			Package[$packages],
			Package[$extensions],
		],
    }
}