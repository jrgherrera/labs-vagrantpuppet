class git () {

	$packages = [
		"git-core",
	]

	$extensions = [
        "g++",
		"curl",
		"libssl-dev",
		"apache2-utils",
	]

	package { $packages :
		ensure    => 'present',
		require   => [
			Package[$extensions],
		],
	}

	package { $extensions :
		ensure    => 'present',
	}

    notify { "git" : 
    	message  => "Git installation: Done!",
    	loglevel => 'notice',
		require => [
			Package[$packages],
			Package[$extensions],
		],
    }
}