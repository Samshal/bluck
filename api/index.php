<?php
require_once 'vendor/autoload.php';

$settings = [
	'settings'=>[
		'determineRouteBeforeAppMiddleware' => true,
		'displayErrorDetails' => true
	]
];

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type, Cache-Control, X-Requested-With, Authorization');
header('Access-Control-Allow-Methods: GET, PUT, POST, DELETE, OPTIONS');

$app = new \Slim\App($settings);

$app->group('/', function(){
	$this->map(
		['GET', 'POST', 'PUT', 'DELETE'],
		'{version}/{module}/{resource}/{action}[/{resourceId}]',
		function($request, $response, $args){
			$globalResponseFormat = [
				"body"=>[
					"errorStatus"=>false,
					"errorMessage"=>NULL,
					"contentData"=>NULL
				],
				"status"=>200
			];

			if ($request->isGet() || $request->isDelete())
			{
				$parsedBody = $request->getQueryParams();
			}
			else
			{
				$parsedBody = $request->getParsedBody();
			}

			if (!is_array($parsedBody)){
				$globalResponse = [
					"body"=>[
						"errorStatus"=>true,
						"errorMessage"=>"No data detected."
					],
					"status"=>400
				];

				return $response->withJson($globalResponse["body"], $globalResponse["status"]);
			}

			$options = array_merge($args, $parsedBody);

			$globalResponse = array_replace_recursive($globalResponseFormat, Bluck\Router\Middleware::processor($options));

				return $response->withJson($globalResponse["body"], $globalResponse["status"]);
	})->add(Bluck\Router\Middleware::validateRequest());
});
// ->add(Bluck\Router\Middleware::permissionGateway());

$app->run();
