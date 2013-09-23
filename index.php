<?php

require_once('lib/glue/glue.php');
require_once 'lib/php-activerecord/ActiveRecord.php';
require_once 'lib/Twig/Autoloader.php';
Twig_Autoloader::register();

$connections = array(
	'development' => 'sqlite://:memory:'
);


ActiveRecord\Config::initialize(function($cfg)
{
  $cfg->set_model_directory('models/');
  $cfg->set_connections(array('development' =>
    'mysql://username:password@localhost/database_name'));
});

$urls = array(
	'/' => 'index',
	'/users' => 'users',
	'/register' => 'register',
	'/login' => 'login'
);


glue::stick($urls);

class viewmodel {
	protected $twig;
	function __construct() {
		$loader = new Twig_Loader_Filesystem('views');
		$this->twig = new Twig_Environment($loader);
	}
}

class index extends viewmodel {
	function GET() {
		echo $this->twig->render('index.html', array('name' => 'Sean'));
	}
}


class users extends viewmodel {
	function GET() {

	}
}

class register extends viewmodel {
}

class login extends viewmodel {
	function POST() {
		print_r($_POST);
	}

}