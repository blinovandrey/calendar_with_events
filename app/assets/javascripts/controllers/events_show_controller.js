app.controller("EventsShowController", function($scope, $routeParams, eventResource, $location) {
  eventResource.show({id: $routeParams.id }, function(response) {
    $scope.event = response.event
  });

  $scope.back = function() {
    $location.path("/calendar");
  }
});
