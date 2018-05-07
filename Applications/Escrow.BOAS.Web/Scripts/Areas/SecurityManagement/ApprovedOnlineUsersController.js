angular.module('myApp').controller('ApprovedOnlineUsersController', function ($scope, $window, $http, $location, $routeParams, $filter, isundefinedornullservice, globalvalueservice) {
    
    $scope.LoadUserApprovedList = function () {
        $scope.rowCollection = [];
        $http.get('Account/GetAllApprovedOnlineUser')
           .success(function (data) {
               if (data.success) {
                   $scope.rowCollection = data.investors;
                   $scope.displayedCollection = [].concat($scope.rowCollection);
               }
               else {
                   toastr.error(data.errorMessage);
               }
           })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    }

    
});