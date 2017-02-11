var app = angular.module("Bluck", ['ngRoute']);

app.config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider){
	$routeProvider
	.when('/', {
		templateUrl: 'pages/dashboard.html'
	})
	.when('/login', {
		templateUrl: 'pages/auth/login.html'
	})
	.when('/register', {
		templateUrl: 'pages/auth/register.html'
	})
	.otherwise({
		redirectTo: '/'
	});

	$locationProvider.html5Mode(true);
}]);

app.controller("coreController", ['$scope', function($scope){
	$scope.thispage = {};

	$scope.thispage.isAuthPage = true;
}])