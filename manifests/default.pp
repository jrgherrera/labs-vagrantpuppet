Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

exec { 'apt-get update':
	command   => '/usr/bin/apt-get update',
	subscribe => Exec["nameserver"],
}

exec { 'nameserver':
	command => 'echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null'
}

class { 'apache' :
	servername => "localhost",
}

class { 'mysql' :
	password => "root",
}

class { 'php' :
}