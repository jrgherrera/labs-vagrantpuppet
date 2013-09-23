Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

exec { 'apt-get update':
	command   => '/usr/bin/apt-cache search dude',
	subscribe => [
		Exec["nameserver"],
		Exec["timezone"],
	],
}

exec { 'nameserver':
	command => 'echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null'
}

exec { 'timezone':
	command => 'echo "America/Chicago" | sudo tee /etc/timezone'
}

class { 'apache' :
	servername => "localhost",
}

class { 'mysql' :
	user     => "root",
	password => "root",
	database => "db_project",
}

class { 'php' : }
	
class { 'sendmail' : }
