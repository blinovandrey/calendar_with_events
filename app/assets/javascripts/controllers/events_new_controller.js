app.controller("EventsNewController", function($scope, $routeParams, eventResource, repeats, $location, flashService) {
  $scope.event = new eventResource();
  $scope.event.repeat = "once";
  repeats.then(function(data) { $scope.repeats = data; });

  $scope.save = function() {
    eventResource.create($scope.event,
      function(response) { 
        flashService.push("Event successfully created!");
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