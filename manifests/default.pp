include apt

$www_packages = ['php5','sqlite3','php5-sqlite','git']

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

file{ "default apache vhost":
  path=> "/etc/apache2/sites-available/default",
  ensure=> present,
  source=> "/tmp/vagrant-puppet/manifests/conf/default",
  owner=> root,
}

file{ "sqlite db perms":
  path=> "/var/www/data.db",
  owner=>www-data,
  require=> Exec["sqlite setup"]
}

exec{ "rm index.html":
  path   => "/usr/bin:/usr/sbin:/bin",
  command=>"rm /var/www/index.html",
  onlyif => ["test -f /var/www/index.html"],
}

exec{ "git clone":
  path   => "/usr/bin:/usr/sbin:/bin",
  command => "git clone --recursive https://github.com/sc68cal/sample-glueapp.git /var/www",
  require => Exec["rm index.html"],
  onlyif => ["test ! -d /var/www/.git "],
}

exec { "sqlite setup":
  path   => "/usr/bin:/usr/sbin:/bin",
  command => "sqlite3 /var/www/data.db < /var/www/db/schema.sqlite",
  onlyif => ["test ! -f /var/www/data.db"],
  require => Exec['git clone']
}

file{ "www folder":
  path=> "/var/www/",
  owner=>www-data,
}
