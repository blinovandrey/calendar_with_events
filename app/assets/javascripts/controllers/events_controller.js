app.controller("EventsController", ["$scope","$http","$location","eventResource","ngDialog",
  function($scope,$http,$location, eventResource, ngDialog) {

    var offset = 0;
    $scope.events = [];
    var count = 0;

    $scope.loadEvents = function(date, offset, by_user = false) {
      eventResource.index({ "day": date, "offset": offset, "by_user": by_user }, function(response) {
      response.forEach(function(event) { $scope.events.push(event); });  
      if (count == 0) {
        angular.element(document).ready(function () {
          var iWidth = document.querySelector('.events-list').clientWidth;
          document.querySelector('.events-list-header').style.width = iWidth + 'px';
        });
      }
        
    });}

    if ($scope.day.events_count > 0) {
      $scope.loadEvents($scope.day.date, offset, $scope.by_user);
    }

    $scope.loadMore = function() {
      offset += 20;
      if ($scope.day.events_count > offset) $scope.loadEvents($scope.day.date, offset, $scope.by_user);
    };

    $scope.new = function(event) {
      ngDialog.close();
      $location.path("/events/new");
    }

    $scope.show = function(event) {
      ngDialog.close();
      if (event.mine)
        $location.path("/events/" + event.id +"/edit");
      else 
        $location.path("/events/" + event.id);
    }

    $scope.delete = function(event, index) {
      eventResource.destroy({id: event.id }, function() {
      $scope.events.splice(index, 1);
      });
    }
  }
]);