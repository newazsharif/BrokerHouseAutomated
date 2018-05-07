angular.module('myApp').controller('UserListController', function ($scope, $window, $http, $location, $routeParams, $filter, dateconfigservice, isundefinedornullservice, globalvalueservice) {
    $scope.loadUserList = function () {
        $scope.rowCollection = [];
        $http.get('/Account/LoadUserList/').
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
})