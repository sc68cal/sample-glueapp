<?php

require_once('lib/glue/glue.php');
require_once 'lib/php-activerecord/ActiveRecord.php';
require_once 'lib/Twig/Autoloader.php';
require_once 'models/user.php';

Twig_Autoloader::register();


ActiveRecord\Config::initialize(function($cfg)
{
  $cfg->set_model_directory('models/');
  $cfg->set_connections(array('development' => 'sqlite://data.db',
  ));
  $cfg->set_default_connection('development');
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
		echo $this->twig->render('index.html');
	}
}


class users extends viewmodel {
	function GET() {
		echo $this->twig->render('users.html', array('users' => User::find('all')));
	}
}

class register extends viewmodel {
	function POST() {
		User::create($_POST);
	}
}

class login extends viewmodel {
	function POST() {
		print_r($_POST);
	}

}
