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
}