app.factory("eventResource", function($resource) {
  return $resource("/events/:id.json", { id: "@id" },
    {
      'create':  { method: 'POST' },
      'index':   { method: 'GET', params: {}, isArray: true },
      'show':    { method: 'GET', isArray: false },
      'update':  { method: 'PUT' },
      'destroy': { method: 'DELETE' }
    }
  );
});

app.factory("sessionResource", function($resource) {
  return $resource("/sessions", {},
    {
      'create':  { method: 'POST' },
      'destroy': { method: 'DELETE' },
      'current_user': { method: 'GET', isArray: false }
    }
  );
});

app.factory("repeats", function($http) {
  return $http.get("/repeats").then(function(response) {
    return response.data;
  });
});

app.factory("flashService", function ($rootScope) {
  var queue = [];
  var currentMessage = "";

  $rootScope.$on("$routeChangeSuccess", function() {
    currentMessage = queue.shift() || "";
  });

  return {
    push: function (msg) {
      queue.push(msg);
    },
    get: function () {
      return currentMessage;
    }
  };
});