include apt

$www_packages = ['php5','sqlite']



exec { "apt-get update":
    command => "/usr/bin/apt-get update",
}

package { $www_packages: 
		ensure => 'installed',
	  	require  => Exec['apt-get update'],
}
