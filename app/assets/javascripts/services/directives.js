app.directive('whenScrolled', function() {
  return function(scope, elem, attr) {
    var raw = elem[0];
    
    elem.bind('scroll', function() {
      if (raw.scrollTop + raw.offsetHeight >= raw.scrollHeight) {
          scope.$apply(attr.whenScrolled);
      }
    });
  };
});




app.directive('datetimepickerNeutralTimezone', function() {
  return {
    restrict: 'A',
    priority: 1,
    require: 'ngModel',
    link: function (scope, element, attrs, ctrl) {
      ctrl.$formatters.push(function (value) {
        var date = new Date(Date.parse(value));
        if (value !== null) date = new Date(date.getTime() + (60000 * date.getTimezoneOffset()));
        else date = null;
        return date;
      });

      ctrl.$parsers.push(function (value) {
        if (value !== null) var date = new Date(value.getTime() - (60000 * value.getTimezoneOffset()));
        else var date = null;
        return date;
      });
    }
  };
});