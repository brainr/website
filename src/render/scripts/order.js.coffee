app = angular.module 'orderPage', ['ngMaterial']

app.controller 'OrderNavCtrl', ($scope, $timeout, $mdSidenav, $log) ->
	$scope.openNav = ->
		$mdSidenav('left')
		.open()
		.then ->
			$log.debug "toggle left is done"
	$scope.closeNav = ->
		$mdSidenav('left').close()

app.controller 'OrderCtrl', ($scope, $timeout, $mdSidenav, $log) ->
	1
