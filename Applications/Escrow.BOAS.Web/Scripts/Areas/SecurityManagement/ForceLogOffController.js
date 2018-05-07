angular.module('myApp').controller('ForceLogOffController', function ($scope, $window, $http, $location, $routeParams, $filter, dateconfigservice, isundefinedornullservice, globalvalueservice) {
    $scope.LoadUserListForLogOff = function () {
        $scope.rowCollection = [];
        $http.get('/Account/LoadUserListForLogOff/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.users;
                  $scope.displayedCollection = [].concat($scope.rowCollection);
              }
              else {
                  toastr.error(data.errorMessage);
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.ForceLogOffById = function (id) {
        $http({
            method: 'POST',
            url: '/Account/ForceLogOffById',
            data: { id: id }
        }).success(function(data) {
            if (data.success) {
                toastr.success(data.message);
                $scope.LoadUserListForLogOff();
            } else {
                toastr.error(data.errorMessage);
            }
        }).error(function(XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };

});