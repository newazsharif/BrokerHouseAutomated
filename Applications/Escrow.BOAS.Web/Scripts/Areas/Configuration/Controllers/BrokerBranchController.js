angular.module('myApp').controller('BrokerBranchController', function ($scope, $window, $http, $location, $routeParams, dateconfigservice) {

    $('#pageTitle').text("--- Broker Branch");

    $scope.loadBrokerList = function () {
        $scope.rowCollection = [];
        $http.get('/Configuration/BrokerBranch/getBrokerBranchList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.brokerBranches;
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

    $scope.loadBrokerBranchAndDdlById = function () {
        $scope.activeStatusList = null;
        $http.get('/Configuration/BrokerBranch/getActiveStatusDdlList/').
          success(function (data) {
              $scope.activeStatusList = data;
              $scope.loadBrokerBranchById($routeParams.id);
          }).
          error(function (data) {
              toastr.error("Failed Please try again");
              $location.path('/BrokerBranch');
          });
    };

    $scope.loadBrokerBranchById = function (brokerBranchId) {
        $http.get('/Configuration/BrokerBranch/getBrokerBranchById/' + brokerBranchId).
          success(function (data) {
              if (data.success) {
                  $scope.editBroker = data.brokerBranch;
              }
              else {
                  toastr.error(data.errorMessage);
                  $location.path('/BrokerBranch');
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
              $location.path('/BrokerBranch');
          });
    };

    $scope.editBrokerBranch = function () {

        if ($scope.editBrokBraForm.$valid) {

            $scope.editBroker.registration_dt = dateconfigservice.FullDateUKtoDateKey($scope.editBroker.regis_dt);

            $http({
                  method: 'POST',
                  url: '/Configuration/BrokerBranch/updateBrokerBranch',
                  data: $scope.editBroker
              }).success(function (data) {
                  if (data.success) {
                      toastr.success("Submitted Successfully");
                      $location.path('/BrokerBranch');
                  }
                  else {
                      toastr.error(data.errorMessage);
                  }
              }).
            error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
        }
    };

    $scope.UpdateAccountMapping = function() {
        $http({
            method: 'POST',
            url: '/Configuration/BrokerBranch/updateBrokerBranch',
            data: $scope.editBroker
        }).success(function (data) {
            if (data.success) {
                toastr.success("Submitted Successfully");
                $location.path('/BrokerBranch');
            }
            else {
                toastr.error(data.errorMessage);
            }
        }).
            error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
    }

});