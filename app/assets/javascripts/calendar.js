var app = angular.module('calendar',['ngRoute', 'templates', 'ngDialog', 'ngResource','ui.bootstrap']);

app.config([
  "$routeProvider","$locationProvider",
  function($routeProvider, $locationProvider) {
    $locationProvider.html5Mode(true);
    $routeProvider.when('/calendar', {
      controller: "CalendarController",
      templateUrl: "calendar.html"
    }).when('/events/:id/edit', {
      controller: "EventsEditController",
      templateUrl: "eventEdit.html"
    }).when('/events/new', {
      controller: "EventsNewController",
      templateUrl: "eventNew.html"
    }).when('/events/:id/', {
      controller: "EventsShowController",
      templateUrl: "eventShowForm.html"
    });
  }
]);
