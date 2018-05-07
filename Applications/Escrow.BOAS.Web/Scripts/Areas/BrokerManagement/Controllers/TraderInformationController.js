angular.module('myApp').controller('TraderInformationController', function ($scope, $window, $http, $location, $routeParams, $filter, dateconfigservice, globalvalueservice) {

    $('#pageTitle').text("--- Trader Information");

    $scope.open = function ($event, opened) {
        $event.preventDefault();
        $event.stopPropagation();

        $scope[opened] = true;
    };

    $scope.loadTraderList = function () {
        $scope.rowCollection = [];
        $http.get('/BrokerManagement/TraderInformation/getTraderList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.traderList;
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

    $scope.loadDropdowns = function () {
        $scope.tradaerInformation.license_renew_date = globalvalueservice.getProcessDate();

        $scope.loadEmployee();
        $scope.loadActiveStatus();
        $scope.loadBranch();
    };

    $scope.loadEmployee = function () {
        $scope.employeeList = null;
        $http.get('/BrokerManagement/TraderInformation/getEmployeeDdlList/').
          success(function (data) {
              $scope.employeeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadBranch = function () {
        $scope.branchList = null;
        $http.get('/BrokerManagement/TraderInformation/getBranchDdlList/').
          success(function (data) {
              $scope.branchList = data;
              $scope.tradaerInformation.broker_branch_id = data[0].value;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadActiveStatus = function () {
        $scope.activeStatusList = null;
        $http.get('/BrokerManagement/TraderInformation/getActiveStatusDdlList/').
          success(function (data) {
              $scope.activeStatusList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.tradaerInformation = {};
    $scope.saveNewTrader = function () {

        if ($scope.newTraderForm.$valid) {

            var datefilter = $filter('date');

            var licenseRenewDate = datefilter($scope.tradaerInformation.license_renew_date, 'dd/MM/yyyy');

            $scope.tradaerInformation.license_renew_dt = dateconfigservice.FullDateUKtoDateKey(licenseRenewDate);

            $http({
                method: 'POST',
                url: '/BrokerManagement/TraderInformation/addTraderInformation',
                data: $scope.tradaerInformation
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/TraderInformationList');
                }
                else {
                    toastr.error(data.errorMessage);
                }
            }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    }

    $scope.loadTraderAndDdlById = function () {
        $scope.loadEmployee();
        $scope.loadActiveStatus();
        $scope.loadTraderById($routeParams.id);
        $scope.loadBranch();
    };

    $scope.loadTraderById = function (id) {
        $http.get('/BrokerManagement/TraderInformation/getTraderById/' + id).
          success(function (data) {
              if (data.success) {
                  $scope.editTradaerInformation = data.editTraderInformation;
              }
              else {
                  toastr.error(data.errorMessage);
                  $location.path('/TraderInformationList');
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
              $location.path('/TraderInformationList');
          });
    };

    $scope.editTrader = function () {
        if ($scope.editTraderForm.$valid) {

            var datefilter = $filter('date');

            var licenseRenewDate = datefilter($scope.editTradaerInformation.license_renew_date, 'dd/MM/yyyy');

            $scope.editTradaerInformation.license_renew_dt = dateconfigservice.FullDateUKtoDateKey(licenseRenewDate);

            $http({
                method: 'POST',
                url: '/BrokerManagement/TraderInformation/updateTraderInformation',
                data: $scope.editTradaerInformation
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/TraderInformationList');
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

    $scope.DeleteTrader = function (row) {
        var isDelete = confirm("Are you sure you want to delete this trader!");
        if (isDelete == true) {
            $http({
                method: 'POST',
                url: '/BrokerManagement/TraderInformation/deleteTrader',
                data: { id: row.id }
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Deleted Successfully");

                    var index = $scope.rowCollection.indexOf(row);
                    if (index !== -1) {
                        $scope.rowCollection.splice(index, 1);
                    }
                }
                else {
                    toastr.error(data.errorMessage);
                }
            }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    }

    $scope.refresh = function () {
        $scope.tradaerInformation = {};
    };
})