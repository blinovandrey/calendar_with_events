app.controller('LogoutController', ["$scope", "$http", "$location",
	function($scope, $http, $location) {
		$scope.logout = function() {
			$http.delete("/logout").then(function() {
				 window.location.href = "/login";
			})
		}
	}]);