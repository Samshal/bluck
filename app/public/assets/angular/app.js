var app = angular.module("Bluck", ['ngRoute']);

app.config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider){
	$routeProvider
	.when('/', {
		templateUrl: 'tpl/index.html'
	})
	.when('/what-is-mmm', {
		templateUrl: 'tpl/docs/whatismmm.html'
	})
	.when('/docs/how-it-works', {
		templateUrl: 'tpl/docs/howmmmworks.html'
	})
	.when('/docs/legality', {
		templateUrl: 'tpl/docs/legality.html'
	})
	.when('/docs/privacy-policy', {
		templateUrl: 'tpl/docs/privacy.html'
	})
	.when('/docs/ideology', {
		templateUrl: 'tpl/docs/ideology.html'
	})
	.when('/docs/charity', {
		templateUrl: 'tpl/docs/charity.html'
	})
	.when('/testimonials', {
		templateUrl: 'tpl/docs/testimonials.html'
	})
	.when('/mmm-abroad', {
		templateUrl: 'tpl/docs/mmmabroad.html'
	})
	.otherwise({
		redirectTo: '/'
	});

	$locationProvider.html5Mode(true);
}]);

app.controller("coreController", ['$scope', function($scope){
	$scope.message = "Hello World";
}])