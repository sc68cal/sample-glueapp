include apt
include php::apache2

exec { "apt-get update":
    command => "/usr/bin/apt-get update",
}

php::module{ 'sqlite': }

package { 'sqlite3':
		ensure => 'installed',
	  require  => Exec['apt-get update'],
}


exec { "sqlite setup":
       command => "/usr/bin/sqlite3 /var/www/data.db < /var/www/db/schema.sqlite",
       require => Package['sqlite3']
}

apache::vhost { '*:80':
      docroot => '/var/www/',
      directories => [ { path => '/var/www', allow_override => ['ALL'] } ],
}
