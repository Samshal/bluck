<?php declare(strict_types=1);

Namespace Bluck\Router\Middleware;

use Psr\Http\Message\RequestInterface;
use Psr\Http\Message\ResponseInterface;

class PermissionGatewayMiddleware implements \Bluck\Router\MiddlewareInterface
{
	protected static function isUserLoggedIn($userToken)
	{
		$session = \EmmetBlue\Plugins\User\Session::load();

		return isset($session[$userToken]);
	}

	protected static function isUserPermitted($userToken, $resource, $permission)
	{
		$session = \EmmetBlue\Plugins\User\Session::load();

		if(isset($session[$userToken]))
		{
			$uuid = $session[$userToken]["uuid"];
			$userLevel = \EmmetBlue\Plugins\User\Account::getStaffRoleAndDepartment($uuid);
			$role = $userLevel["RoleName"];
			$departmemnt = $userLevel["DepartmentName"];

			$role = str_replace(" ", "", strtolower($role));
			$departmemnt = str_replace(" ", "", strtolower($departmemnt));

			$userLevel = $departmemnt."_".$role;

			$data = [
				"roleName"=>$userLevel,
				"permissionName"=>$permission,
				"resourceName"=>$resource
			];

			return \EmmetBlue\Plugins\Permission\ManagePermissions::viewPermission($data);
		}

		return false;
	}

	public function getStandardResponse()
	{
		return function(RequestInterface $request, ResponseInterface $response, callable $next)
		{
			$args = $request->getAttribute('routeInfo')[2];

			$module = $args['module'];
			$resource = $args['resource'];
			$permission = ((array)json_decode(file_get_contents("bin/configs/whitelists.json")))[$request->getMethod()][0];

			$token = (isset($request->getHeaders()["HTTP_AUTHORIZATION"][0])) ? $request->getHeaders()["HTTP_AUTHORIZATION"][0] : "";
			$aclResourceName = str_replace("-", "", strtolower($module."_".$resource));

			if (!self::isUserLoggedIn($token))
			{
				$globalResponse = [];

				$globalResponse["status"] = 401;
				$globalResponse["body"]["errorStatus"] = true;
				$globalResponse["body"]["errorMessage"] = "You havent been logged in or your supplied login token is invalid.";

				return $response->withJson($globalResponse["body"], $globalResponse["status"]);
			}

			try
			{
				if (!self::isUserPermitted($token, $aclResourceName, $permission))
				{
					$globalResponse = [];

					$globalResponse["status"] = 401;
					$globalResponse["body"]["errorStatus"] = true;
					$globalResponse["body"]["errorMessage"] = "You do not have the appropriate permissions to perform the requested operation";

					return $response->withJson($globalResponse["body"], $globalResponse["status"]);
				}
			}
			catch(\Exception $e)
			{
				$globalResponse = [];

				$globalResponse["status"] = 403;
				$globalResponse["body"]["errorStatus"] = true;
				$globalResponse["body"]["errorMessage"] = "Authentication failed, please resend a valid request. ".$e->getMessage();

				return $response->withJson($globalResponse["body"], $globalResponse["status"]);
			}

			return $next($request, $response);
		};
	}
}
