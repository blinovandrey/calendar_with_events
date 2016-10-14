app.controller("CalendarController", ["$scope","$http","ngDialog","$location","flashService",
  function($scope,$http,ngDialog,$location,flashService) {
    $scope.year = new Date().getFullYear();
    $scope.month = new Date().getMonth() + 1;
    $scope.months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    $scope.loadCalendar = function(year, month, by_user = false) {
      if (year.toString().length !== 4 || year < 1900 || year > 3000) return;
      $http.get("/calendar.json", { "params": { "year": year, "month": month, "by_user": by_user } }).then(
      function(response) { $scope.calendar = response.data; },
      function(response) { alert("There was a problem: " + response.status); }
      );
    }

    $scope.loadCalendar($scope.year, $scope.month);

    $scope.loadCalendarPreviousMonth = function() {
      if ($scope.month == 1) {
        if ($scope.year <= 1900) return;
        $scope.month = 12;
        $scope.year = $scope.year - 1;
      }
      else $scope.month = $scope.month - 1;
      $scope.loadCalendar($scope.year, $scope.month, $scope.by_user);
    }

    $scope.loadCalendarNextMonth = function() {
      if ($scope.month == 12) {
        if ($scope.year >= 3000) return;
        $scope.month = 1;
        $scope.year = $scope.year + 1;
      }
      else $scope.month = $scope.month + 1;
      $scope.loadCalendar($scope.year, $scope.month, $scope.by_user);
    }

    $scope.setAllActive = function() {
      if ($scope.by_user) {
      $scope.by_user = false;
      $scope.loadCalendar($scope.year, $scope.month, $scope.by_user);
      } 
    }

    $scope.setMyActive = function() {
      if (!$scope.by_user) {
      $scope.by_user = true;
      $scope.loadCalendar($scope.year, $scope.month, $scope.by_user);
      }
    }

    $scope.getDate = function(datestring) {
      return new Date(datestring).getDate();
    }

    $scope.getMonth = function(datestring) {
      return new Date(datestring).getMonth();
    }

    $scope.hoverIn = function() { this.hovered = true;}
    $scope.hoverOut = function() { this.hovered = false;}

    $scope.getFlashMessage = function() { return flashService.get(); }

    var dialogIndex = 1;
    $scope.openTasks = function(day) {
      $scope.day = day;
      ngDialog.open({
          template: 'events.html',
          className: 'ngdialog-theme-default custom-width',
          controller: 'EventsController',
          scope: $scope
      });
    }

    $scope.logout = function() {
      $http.delete("/logout").then(function() {
         window.location.href = "/login";
      })
    }
  }
]);