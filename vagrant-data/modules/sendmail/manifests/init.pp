class sendmail {

	package { 'sendmail' :
		ensure  => 'present',
		require => Exec["apt-get update"],
	}

	service{ 'sendmail' :
		enable => true,
		ensure => running,
		hasstatus => true,
		require => Package["sendmail"],
	}

    notify { "SendMail installation: Done!" : 
    	loglevel => 'notice',
    	require  => Package["sendmail"],
    }
}