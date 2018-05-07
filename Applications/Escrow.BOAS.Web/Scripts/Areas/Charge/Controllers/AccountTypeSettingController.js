angular.module('myApp').controller('AccountTypeSettingController', function ($scope, $window, $http, $location, $routeParams, isundefinedornullservice) {

    $('#pageTitle').text("--- Account Type Setting");

    $scope.loadAccTypeSettingList = function () {

        $scope.rowCollection = [];
        $http.get('/Charge/AccountTypeSetting/getAccTypeSettingList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.accountTypeSetting;
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

    $scope.DeleteAccTypeSetting = function (row) {
        var isDelete = confirm("Are you sure you want to delete this setting!");
        if (isDelete == true) {
            $http({
                method: 'POST',
                url: '/Charge/AccountTypeSetting/deleteAccTypeSetting',
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

    $scope.loadDropdowns = function () {
        $scope.loadTransactionOn();
        $scope.loadAccountType();
    };

    $scope.loadDropdownsForEdit = function () {
        $scope.loadAccountTypeForEdit();
    };

    $scope.loadTransactionOn = function () {
        $scope.minimumBalanceOnList = null;
        $scope.wthdrawLimitOnList = null;
        $scope.loadOnList = null;
        $scope.profitOnList = null;
        $http.get('Charge/AccountTypeSetting/getTransactionOnDdlList/').
          success(function (data) {
              $scope.minimumBalanceOnList = data;
              $scope.wthdrawLimitOnList = data;
              $scope.loadOnList = data;
              $scope.profitOnList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadAccountType = function () {
        $scope.investorAccountTypeList = null;
        $http.get('/Charge/AccountTypeSetting/getddlInvestorAccType/').
          success(function (data) {
              $scope.investorAccountTypeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadTransactionOnForEdit = function () {
        $scope.minimumBalanceOnList = null;
        $scope.wthdrawLimitOnList = null;
        $scope.loadOnList = null;
        $scope.profitOnList = null;
        $http.get('Charge/AccountTypeSetting/getTransactionOnDdlList/').
          success(function (data) {
              $scope.minimumBalanceOnList = data;
              $scope.wthdrawLimitOnList = data;
              $scope.loadOnList = data;
              $scope.profitOnList = data;
              $scope.loadAccTypeSettingById($routeParams.id);
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadAccountTypeForEdit = function () {
        $scope.investorAccountTypeList = null;
        $http.get('/Charge/AccountTypeSetting/getddlInvestorAccType/').
          success(function (data) {
              $scope.investorAccountTypeList = data;
              $scope.loadTransactionOnForEdit();
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.accountTypeSetting = {};
    $scope.addAccTypeSetting = function () {

        if ($scope.newAccTypeSettingForm.$valid) {
            if (isundefinedornullservice.isUndefinedOrNull($scope.accountTypeSetting.minimum_balance_is_percentage) || $scope.accountTypeSetting.minimum_balance_is_percentage.toString().trim() == "") {
                $scope.accountTypeSetting.minimum_balance_is_percentage = 0;
            }
            if (isundefinedornullservice.isUndefinedOrNull($scope.accountTypeSetting.withdraw_limit_on) || $scope.accountTypeSetting.withdraw_limit_on.toString().trim() == "") {
                $scope.accountTypeSetting.withdraw_limit_on = 0;
            }
            if (isundefinedornullservice.isUndefinedOrNull($scope.accountTypeSetting.loan_ratio) || $scope.accountTypeSetting.loan_ratio.toString().trim() == "") {
                $scope.accountTypeSetting.loan_ratio = 0;
            }
            $http({
                method: 'POST',
                url: '/Charge/AccountTypeSetting/AddAccTypeSetting',
                data: $scope.accountTypeSetting
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/AccountTypeSettingList');
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

    $scope.loadDropdownsAndInfo = function () {
        $scope.loadAccountTypeForEdit();
    };

    $scope.loadAccTypeSettingById = function (id) {
        $http.get('/Charge/AccountTypeSetting/getAccTypeSettingById/' + id).
          success(function (data) {
              if (data.success) {
                  $scope.editAccountTypeSetting = data.accountTypeSetting;
              }
              else {
                  toastr.error(data.errorMessage);
                  $location.path('/AccountTypeSettingList');
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
              $location.path('/AccountTypeSettingList');
          });
    };

    $scope.updateAccTypeSetting = function () {

        if ($scope.editAccTypeSettingForm.$valid) {
            if (isundefinedornullservice.isUndefinedOrNull($scope.editAccountTypeSetting.minimum_balance_is_percentage) || $scope.editAccountTypeSetting.minimum_balance_is_percentage.toString().trim() == "") {
                $scope.editAccountTypeSetting.minimum_balance_is_percentage = 0;
            }
            if (isundefinedornullservice.isUndefinedOrNull($scope.editAccountTypeSetting.withdraw_limit_on) || $scope.editAccountTypeSetting.withdraw_limit_on.toString().trim() == "") {
                $scope.editAccountTypeSetting.withdraw_limit_on = 0;
            }
            if (isundefinedornullservice.isUndefinedOrNull($scope.editAccountTypeSetting.loan_ratio) || $scope.editAccountTypeSetting.loan_ratio.toString().trim() == "") {
                $scope.editAccountTypeSetting.loan_ratio = 0;
            }
            $http({
                method: 'POST',
                url: '/Charge/AccountTypeSetting/UpdateAccTypeSetting',
                data: $scope.editAccountTypeSetting
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/AccountTypeSettingList');
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
        $scope.accountTypeSetting = {};
    };
})