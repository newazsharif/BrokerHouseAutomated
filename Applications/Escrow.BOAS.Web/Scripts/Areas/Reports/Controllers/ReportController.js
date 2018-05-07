angular.module('myApp').controller('ReportController', function ($scope, $window, $http, $location, $routeParams, $filter, dateconfigservice, globalvalueservice) {

    $('#pageTitle').text("--- Reports");

    $scope.field_id = "";

    $scope.field_value = "";

    $scope.field_type = "";

    $scope.opened = [];
    $scope.open = function ($event, index) {
        $event.preventDefault();
        $event.stopPropagation();

        $scope.opened[index] = true;
    };

    $scope.loadBranch = function () {
        $scope.branchList = null;
        $http.get('/Reports/Report/getBranchDdlList/').
          success(function (data) {
              $scope.branchList = data;
          }).
          error(function (data) {
              toastr.error("Failed Please try again");
          });
    };

    $scope.loadDesignation = function () {
        $scope.designationList = null;
        $http.get('/Reports/Report/getDesigDdlList/').
          success(function (data) {
              $scope.designationList = data;
          }).
          error(function (data) {
              toastr.error("Failed Please try again");
          });
    };

    $scope.loadDepartment = function () {
        $scope.departmentList = null;
        $http.get('/Reports/Report/getDepDdlList/').
          success(function (data) {
              $scope.departmentList = data;
          }).
          error(function (data) {
              toastr.error("Failed Please try again");
          });
    };

    $scope.loadActiveStatus = function () {
        $scope.departmentList = null;
        $http.get('/Reports/Report/getActiveStatusDdlList/').
          success(function (data) {
              $scope.activeStatusList = data;
          }).
          error(function (data) {
              toastr.error("Failed Please try again");
          });
    };

    $scope.loadInvestorAccountType = function () {
        $scope.departmentList = null;
        $http.get('/Reports/Report/getddlInvestorAccType/').
          success(function (data) {
              $scope.investorAccountTypeList = data;
          }).
          error(function (data) {
              toastr.error("Failed Please try again");
          });
    };

    $scope.loadInvestorSubAccountType = function () {
        $scope.departmentList = null;
        $http.get('/Reports/Report/getddlInvestorSubAccType/').
          success(function (data) {
              $scope.investorSubAccountTypeList = data;
          }).
          error(function (data) {
              toastr.error("Failed Please try again");
          });
    };

    $scope.loadTransactionMode = function () {
        $scope.transactionModeList = null;
        $http.get('/Reports/Report/getTransactionModeDdlList/').
          success(function (data) {
              $scope.transactionModeList = data;
          }).
          error(function (data) {
              toastr.error("Failed Please try again");
          });
    };


    $scope.loadChargeType = function () {
        $scope.ChargeTypelist = null;
        $http.get('/Reports/Report/getddlChargeTypelist/').
          success(function (data) {
              $scope.ChargeTypelist = data;
          }).
          error(function (data) {
              toastr.error("Failed Please try again");
          });
    };

    $scope.loadIsApproved = function () {
        $scope.isApprovedList = [
      { value: '2', text: 'All' },
      { value: '1', text: 'Approve' },
      { value: '0', text: 'Unapprove' }
        ];
    };

    $scope.loadDynamicView = function () {
        var process_date = globalvalueservice.getProcessDate();
        $http.get('/Reports/Report/getDynamicView?ViewId=' + $routeParams.ViewId + '').
          success(function (data) {
              if (data.success) {
                  $scope.dynamicView = data.dynamicView;
                  $scope.title = data.title;
                  $scope.header = data.header;
                  $scope.reportName = data.reportName;
                  $scope.reportDataSource = data.reportDataSource;
                  $scope.spName = data.spName;
                  for (var i = 0; i < $scope.dynamicView.length; i++) {
                      $scope.field_id = $scope.field_id + "," + $scope.dynamicView[i].field_id;
                      $scope.field_type = $scope.field_type + "," + $scope.dynamicView[i].field_type;
                      if ($scope.dynamicView[i].field_type == "dropdown" && $scope.dynamicView[i].field_id == "branch_id") {
                          $scope.loadBranch();
                      }
                      else if ($scope.dynamicView[i].field_type == "dropdown" && $scope.dynamicView[i].field_id == "designation_id") {
                          $scope.loadDesignation();
                      }
                      else if ($scope.dynamicView[i].field_type == "dropdown" && $scope.dynamicView[i].field_id == "designation_id") {
                          $scope.loadDesignation();
                      }
                      else if ($scope.dynamicView[i].field_type == "dropdown" && $scope.dynamicView[i].field_id == "active_status_id") {
                          $scope.loadActiveStatus();
                      }
                      else if ($scope.dynamicView[i].field_type == "dropdown" && $scope.dynamicView[i].field_id == "account_type_id") {
                          $scope.loadInvestorAccountType();
                      }
                      else if ($scope.dynamicView[i].field_type == "dropdown" && $scope.dynamicView[i].field_id == "sub_account_type_id") {
                          $scope.loadInvestorSubAccountType();
                      }
                      else if ($scope.dynamicView[i].field_type == "dropdown" && $scope.dynamicView[i].field_id == "transaction_mode_id") {
                          $scope.loadTransactionMode();
                      }
                      else if ($scope.dynamicView[i].field_type == "dropdown" && $scope.dynamicView[i].field_id == "is_approved") {
                          $scope.loadIsApproved();
                      }
                      else if ($scope.dynamicView[i].field_type == "dropdown" && $scope.dynamicView[i].field_id == "charge_type_id") {
                          $scope.loadChargeType();
                      }
                      else if (($scope.dynamicView[i].field_type == "date" || $scope.dynamicView[i].field_type == "daterange") && $scope.dynamicView[i].field_value == "process date") {
                          $scope.dynamicView[i].field_value = process_date;
                      }
                  }

              }
              else {
                  toastr.error(data.errorMessage);
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.setDynamicProperty = function (e) {
        e.preventDefault();
        var datefilter = $filter('date');
        var dt;
        $scope.field_value = "";
        for (var i = 0; i < $scope.dynamicView.length; i++) {
            if ($scope.dynamicView[i].field_type == "date" || $scope.dynamicView[i].field_type == "daterange") {
                dt = datefilter($scope.dynamicView[i].field_value, 'dd/MM/yyyy');
                $scope.field_value = $scope.field_value + "," + dateconfigservice.FullDateUKtoDateKey(dt);
            }
            else {
                $scope.field_value = $scope.field_value + "," + $scope.dynamicView[i].field_value;
            }
        }
    };

});