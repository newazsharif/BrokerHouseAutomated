angular.module('myApp').controller('BranchAccountTypeSettingController', function ($scope, $window, $http, $location, $routeParams, isundefinedornullservice) {

    $('#pageTitle').text("--- Branch Account Type Setting");

    $scope.loadBranchAccTypeSettingList = function () {

        $scope.rowCollection = [];
        $http.get('/Charge/BranchAccountTypeSetting/getBranchAccTypeSettingList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.branchAccTypeSetting;
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

    $scope.DeleteBranchAccTypeSetting = function (row) {
        var isDelete = confirm("Are you sure you want to delete this setting!");
        if (isDelete == true) {
            $http({
                method: 'POST',
                url: '/Charge/BranchAccountTypeSetting/deleteBranchAccTypeSetting',
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
        $scope.loadBranch();
    };

    $scope.loadDropdownsForEdit = function () {
        $scope.loadAccountTypeForEdit();
    };

    $scope.loadTransactionOn = function () {
        $scope.minimumBalanceOnList = null;
        $scope.wthdrawLimitOnList = null;
        $scope.loadOnList = null;
        $scope.profitOnList = null;
        $http.get('Charge/BranchAccountTypeSetting/getTransactionOnDdlList/').
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
        $http.get('/Charge/BranchAccountTypeSetting/getddlInvestorAccType/').
          success(function (data) {
              $scope.investorAccountTypeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadBranch = function () {
        $scope.branchList = null;
        $http.get('/Charge/BranchAccountTypeSetting/getBranchDdlList/').
          success(function (data) {
              $scope.branchList = data;
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
        $http.get('Charge/BranchAccountTypeSetting/getTransactionOnDdlList/').
          success(function (data) {
              $scope.minimumBalanceOnList = data;
              $scope.wthdrawLimitOnList = data;
              $scope.loadOnList = data;
              $scope.profitOnList = data;
              $scope.loadBranchForEdit();
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadAccountTypeForEdit = function () {
        $scope.investorAccountTypeList = null;
        $http.get('/Charge/BranchAccountTypeSetting/getddlInvestorAccType/').
          success(function (data) {
              $scope.investorAccountTypeList = data;
              $scope.loadTransactionOnForEdit();
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadBranchForEdit = function () {
        $scope.branchList = null;
        $http.get('/Charge/BranchAccountTypeSetting/getBranchDdlList/').
          success(function (data) {
              $scope.branchList = data;
              $scope.loadBranchAccTypeSettingById($routeParams.id);
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.branchAccTypeSetting = {};
    $scope.addBranchAccTypeSetting = function () {

        if ($scope.newBranchAccTypeSettingForm.$valid) {
            if (isundefinedornullservice.isUndefinedOrNull($scope.branchAccTypeSetting.minimum_balance_is_percentage) || $scope.branchAccTypeSetting.minimum_balance_is_percentage.toString().trim() == "") {
                $scope.branchAccTypeSetting.minimum_balance_is_percentage = 0;
            }
            if (isundefinedornullservice.isUndefinedOrNull($scope.branchAccTypeSetting.withdraw_limit_on) || $scope.branchAccTypeSetting.withdraw_limit_on.toString().trim() == "") {
                $scope.branchAccTypeSetting.withdraw_limit_on = 0;
            }
            if (isundefinedornullservice.isUndefinedOrNull($scope.branchAccTypeSetting.loan_ratio) || $scope.branchAccTypeSetting.loan_ratio.toString().trim() == "") {
                $scope.branchAccTypeSetting.loan_ratio = 0;
            }
            $http({
                method: 'POST',
                url: '/Charge/BranchAccountTypeSetting/AddBranchAccTypeSetting',
                data: $scope.branchAccTypeSetting
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/BranchAccountTypeSettingList');
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

    $scope.loadBranchAccTypeSettingById = function (id) {
        $http.get('/Charge/BranchAccountTypeSetting/getBranchAccTypeSettingById/' + id).
          success(function (data) {
              if (data.success) {
                  $scope.editBranchAccTypeSetting = data.branchAccTypeSetting;
              }
              else {
                  toastr.error(data.errorMessage);
                  $location.path('/BranchAccountTypeSettingList');
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
              $location.path('/BranchAccountTypeSettingList');
          });
    };

    $scope.updateBranchAccTypeSetting = function () {

        if ($scope.editBranchAccTypeSettingForm.$valid) {
            if (isundefinedornullservice.isUndefinedOrNull($scope.editBranchAccTypeSetting.minimum_balance_is_percentage) || $scope.editBranchAccTypeSetting.minimum_balance_is_percentage.toString().trim() == "") {
                $scope.editBranchAccTypeSetting.minimum_balance_is_percentage = 0;
            }
            if (isundefinedornullservice.isUndefinedOrNull($scope.editBranchAccTypeSetting.withdraw_limit_on) || $scope.editBranchAccTypeSetting.withdraw_limit_on.toString().trim() == "") {
                $scope.editBranchAccTypeSetting.withdraw_limit_on = 0;
            }
            if (isundefinedornullservice.isUndefinedOrNull($scope.editBranchAccTypeSetting.loan_ratio) || $scope.editBranchAccTypeSetting.loan_ratio.toString().trim() == "") {
                $scope.editBranchAccTypeSetting.loan_ratio = 0;
            }
            $http({
                method: 'POST',
                url: '/Charge/BranchAccountTypeSetting/UpdateBranchAccTypeSetting',
                data: $scope.editBranchAccTypeSetting
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/BranchAccountTypeSettingList');
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
        $scope.branchAccTypeSetting = {};
    };
})