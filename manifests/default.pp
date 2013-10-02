include apt

$www_packages = ['php5','sqlite3','php5-sqlite']

class { 'apache':
      default_mods => true,
}


exec { "apt-get update":
    command => "/usr/bin/apt-get update",
}

package { $www_packages: 
		ensure => 'installed',
	  	require  => Exec['apt-get update'],
}


exec { "mod_rewrite":
    command => "/usr/sbin/a2enmod rewrite",
}

exec { "reload":
       command=> "/usr/sbin/apachectl graceful",
       require=> Exec['mod_rewrite']
}

exec { "sqlite setup":
       command => "/usr/bin/sqlite3 /var/www/data.db < /var/www/db/schema.sqlite",
       require=> Exec['reload']
}

apache::vhost { '*:80':
      docroot => '/var/www/',
      directories => [ { path => '/var/www', allow_override => ['ALL'] } ],
      require=> Exec['reload']
}
