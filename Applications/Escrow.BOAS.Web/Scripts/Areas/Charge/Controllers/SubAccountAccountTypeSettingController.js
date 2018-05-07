angular.module('myApp').controller('SubAccountAccountTypeSettingController', function ($scope, $window, $http, $location, $routeParams, isundefinedornullservice) {

    $('#pageTitle').text("---Sub Account Account Type Setting");

    $scope.loadSubAccAccTypeSettingList = function () {

        $scope.rowCollection = [];
        $http.get('/Charge/SubAccountAccountTypeSetting/getSubAccAccTypeSettingList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.subAccountAccountTypeSetting;
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

    $scope.DeleteSubAacAccTypeSetting = function (row) {
        var isDelete = confirm("Are you sure you want to delete this setting!");
        if (isDelete == true) {
            $http({
                method: 'POST',
                url: '/Charge/SubAccountAccountTypeSetting/deleteSubAccAccTypeSetting',
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
        $scope.loadSubAccountType();
    };

    $scope.loadDropdownsForEdit = function () {
        $scope.loadAccountTypeForEdit();
    };

    $scope.loadSubAccountType = function () {
        $scope.subAccountList = null;
        $http.get('Charge/SubAccountAccountTypeSetting/getSubAccountDdlList/').
          success(function (data) {
              $scope.subAccountList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadTransactionOn = function () {
        $scope.minimumBalanceOnList = null;
        $scope.wthdrawLimitOnList = null;
        $scope.loadOnList = null;
        $scope.profitOnList = null;
        $http.get('Charge/SubAccountAccountTypeSetting/getTransactionOnDdlList/').
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
        $http.get('/Charge/SubAccountAccountTypeSetting/getddlInvestorAccType/').
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
        $http.get('Charge/SubAccountAccountTypeSetting/getTransactionOnDdlList/').
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

    $scope.loadSubAccountTypeForEdit = function () {
        $scope.subAccountList = null;
        $http.get('Charge/SubAccountAccountTypeSetting/getSubAccountDdlList/').
        success(function (data) {
            $scope.subAccountList = data;
        }).
        error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    }

    $scope.loadAccountTypeForEdit = function () {
        $scope.investorAccountTypeList = null;
        $http.get('/Charge/SubAccountAccountTypeSetting/getddlInvestorAccType/').
          success(function (data) {
              $scope.investorAccountTypeList = data;
              $scope.loadSubAccountTypeForEdit();
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
                url: '/Charge/SubAccountAccountTypeSetting/AddSubAccAccTypeSetting',
                data: $scope.accountTypeSetting
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/SubAccountAccountTypeSettingList');
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
        $http.get('/Charge/SubAccountAccountTypeSetting/getSubAccAccTypeSettingById/' + id).
          success(function (data) {
              if (data.success) {
                  $scope.editSubAccountAccountTypeSetting = data.subAccountAccountTypeSetting;
              }
              else {
                  toastr.error(data.errorMessage);
                  $location.path('/SubAccountAccountTypeSettingList');
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
              $location.path('/SubAccountAccountTypeSettingList');
          });
    };

    $scope.updateSubAccAccTypeSetting = function () {

        if ($scope.editSubAccAccTypeSettingForm.$valid) {
            if (isundefinedornullservice.isUndefinedOrNull($scope.editSubAccountAccountTypeSetting.minimum_balance_is_percentage) || $scope.editSubAccountAccountTypeSetting.minimum_balance_is_percentage.toString().trim() == "") {
                $scope.editSubAccountAccountTypeSetting.minimum_balance_is_percentage = 0;
            }
            if (isundefinedornullservice.isUndefinedOrNull($scope.editSubAccountAccountTypeSetting.withdraw_limit_on) || $scope.editSubAccountAccountTypeSetting.withdraw_limit_on.toString().trim() == "") {
                $scope.editSubAccountAccountTypeSetting.withdraw_limit_on = 0;
            }
            if (isundefinedornullservice.isUndefinedOrNull($scope.editSubAccountAccountTypeSetting.loan_ratio) || $scope.editSubAccountAccountTypeSetting.loan_ratio.toString().trim() == "") {
                $scope.editSubAccountAccountTypeSetting.loan_ratio = 0;
            }
            $http({
                method: 'POST',
                url: '/Charge/SubAccountAccountTypeSetting/UpdateSubAccAccTypeSetting',
                data: $scope.editSubAccountAccountTypeSetting
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/SubAccountAccountTypeSettingList');
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