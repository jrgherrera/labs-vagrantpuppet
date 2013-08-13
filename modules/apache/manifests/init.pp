class apache ($servername = "") {
	package { 'apache2' :
		ensure  => 'present',
		require => Exec["apt-get update"],
	}

	service { 'apache2' :
		ensure     => 'running',
		enable     => true,
		hasrestart => true,
		require    => Package["apache2"],
		subscribe  => [
			File['apache-virtualhosts'],
			File['apache-modrewrite'],
			Exec['apache-servername'],
		],
	}

	file { 'apache-virtualhosts' :
		path    => '/etc/apache2/sites-enabled/000-default',
		source  => '/vagrant/modules/apache/files/apache-virtualhosts',
		require => Package['apache2'],
	}

	file { 'apache-modrewrite' :
		path    => '/etc/apache2/mods-enabled/rewrite.load',
		ensure	=> 'link',
		target  => '/etc/apache2/mods-available/rewrite.load',
		require => Package['apache2'],
	}

	exec { 'apache-servername' :
		command => "echo \"ServerName ${servername}\" | sudo tee /etc/apache2/conf.d/fqdn",
		require => Package["apache2"],
	}
}