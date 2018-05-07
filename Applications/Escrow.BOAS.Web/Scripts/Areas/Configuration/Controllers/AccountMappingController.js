angular.module('myApp').controller('AccountMappingController', function ($scope, $window, $http, $location, $routeParams, dateconfigservice) {
    $scope.init = function() {
        $scope.GetAllLedgerHead();
        $scope.LoadAllMapping();
    };
    $scope.GetAllLedgerHead = function() {
        $http.get('/Configuration/AccountMapping/GetAllLedgerHead/').
            success(function(data) {
                $scope.headList = data.data;
            }).
            error(function(data) {
                toastr.error("Failed Please try again");
            });
    };

    $scope.LoadAllMapping = function () {
        $scope.rowCollection = [];
        $http.get('/Configuration/AccountMapping/LoadAllMapping/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.data;
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
    $scope.UpdateAccountMapping = function() {
        $http({
                method: 'POST',
                url: '/Configuration/AccountMapping/UpdateAccountMapping',
                data: $scope.rowCollection
            }).success(function(data) {
                if (data.success) {
                    toastr.success("Mapped Successfully");
                    
                } else {
                    toastr.error(data.errorMessage);
                }
            }).
            error(function(XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
    };

})