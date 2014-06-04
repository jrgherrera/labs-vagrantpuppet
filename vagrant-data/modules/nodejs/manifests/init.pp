class nodejs ($repository = "") {

	$packages = [
		"nodejs",
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

	exec { "npm-update" :
		cwd => "/vagrant",
		command => "npm -g update",
		onlyif => ["test -d /vagrant/node_modules"],
		path => ["/bin", "/usr/bin"],
		require => Package['nodejs']
	}

	file { 'nodejs-test' :
		path    => '/var/www/hello-world.js',
		source  => '/vagrant/vagrant-data/modules/nodejs/files/hello-world.js',
		require => [
			Package[$packages],
			Exec['npm-update'],
		],
	}

	# exec { "npm-run" :
	# 	cwd => "/var/www/",
	# 	command => "node hello-world.js",
	# 	onlyif => ["test -f /var/www/hello-world.js"],
	# 	path => ["/bin", "/usr/bin"],
	# 	require => [
	# 		Package[$packages],
	# 		File['nodejs-test'],
	# 	],
	# }

    notify { "nodejs" : 
    	message  => "NodeJS installation: Done!",
    	loglevel => 'notice',
		require => [
			Package[$packages]
		],
    }
}