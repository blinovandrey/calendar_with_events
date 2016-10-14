app.controller("EventsEditController", function($scope, $routeParams, eventResource, $http, $location, flashService) {
  eventResource.show({id: $routeParams.id }, function(response) {
    $scope.event = response.event
    $scope.repeats = response.repeats
    $scope.event.date_start = new Date(response.event.date_start);
    if (response.event.date_end !== null) $scope.event.date_end = new Date(response.event.date_end);
  });

  $scope.save = function() {
    eventResource.update($scope.event,
      function(response) { 
        flashService.push("Event successfully updated!");
        $location.path("/calendar"); 
      },
      function(response) { 
        $scope.errors = response.data;
      });
  }

  $scope.back = function() {
    $location.path("/calendar");
  }

  $scope.datePickerOpen = {};
  $scope.datePickerOpen.isOpenStart = false;
  $scope.datePickerOpen.isOpenEnd = false;

  $scope.setOpenStart = function() {
    $scope.datePickerOpen.isOpenStart = true;
  };

  $scope.setOpenEnd = function() {
    $scope.datePickerOpen.isOpenEnd = true;
  };

  $scope.dropLastDayFlag = function() {
  if ($scope.event.date_start !== null && $scope.event.date_start.getDate() <= 28) 
    $scope.event.last_day_of_month = false; }
});