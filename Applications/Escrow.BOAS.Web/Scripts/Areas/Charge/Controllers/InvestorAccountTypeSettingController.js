angular.module('myApp').controller('InvestorAccountTypeSettingController', function ($scope, $window, $http, $location, $routeParams, isundefinedornullservice) {

    $('#pageTitle').text("--- Investor Account Type Setting");

    $scope.image = '../Images/images.png';
    $scope.signature = '../Images/signature.jpg';

    $scope.loadInvAccTypeSettingList = function () {

        $scope.rowCollection = [];
        $http.get('/Charge/InvestorAccountTypeSetting/getInvAccTypeSettingList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.invAccTypeSetting;
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

    $scope.DeleteInvAccTypeSetting = function (row) {
        var isDelete = confirm("Are you sure you want to delete this setting!");
        if (isDelete == true) {
            $http({
                method: 'POST',
                url: '/Charge/InvestorAccountTypeSetting/deleteInvAccTypeSetting',
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

    $scope.getInvestorInfoForAdd = function () {
        $scope.customStyle = {};
        var client_id = $scope.invAccTypeSetting.client_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Charge/InvestorAccountTypeSetting/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.invAccTypeSetting.first_holder_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.invAccTypeSetting.invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.invAccTypeSetting.invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.invAccTypeSetting.invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.invAccTypeSetting.invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.invAccTypeSetting.invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.invAccTypeSetting.invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.invAccTypeSetting.invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.invAccTypeSetting.invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.invAccTypeSetting.first_holder_name += " and " + data.investor.join_holder_name;
                  }

                  $scope.invAccTypeSetting.available_balance = data.investor.available_balance;
                  $scope.invAccTypeSetting.ledger_balance = data.investor.ledger_balance;
                  $scope.invAccTypeSetting.active_status_id = data.investor.active_status_id;
                  $scope.invAccTypeSetting.fldInv = true;
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.invAccTypeSetting.first_holder_name = data.errorMessage;
                  $scope.invAccTypeSetting.fldInv = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.invAccTypeSetting.first_holder_name = "";
              $scope.invAccTypeSetting.fldInv = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.getInvestorInfoForEdit = function () {
        $scope.customStyle = {};
        var client_id = $scope.editInvAccTypeSetting.client_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Charge/InvestorAccountTypeSetting/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.editInvAccTypeSetting.first_holder_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.editInvAccTypeSetting.invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editInvAccTypeSetting.invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.editInvAccTypeSetting.invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editInvAccTypeSetting.invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.editInvAccTypeSetting.invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editInvAccTypeSetting.invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.editInvAccTypeSetting.invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editInvAccTypeSetting.invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.editInvAccTypeSetting.first_holder_name += " and " + data.investor.join_holder_name;
                  }

                  $scope.editInvAccTypeSetting.available_balance = data.investor.available_balance;
                  $scope.editInvAccTypeSetting.ledger_balance = data.investor.ledger_balance;
                  $scope.editInvAccTypeSetting.active_status_id = data.investor.active_status_id;
                  $scope.editInvAccTypeSetting.fldInv = true;
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.editInvAccTypeSetting.first_holder_name = data.errorMessage;
                  $scope.editInvAccTypeSetting.fldInv = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.editInvAccTypeSetting.first_holder_name = "";
              $scope.editInvAccTypeSetting.fldInv = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.loadTransactionOn = function () {
        $scope.minimumBalanceOnList = null;
        $scope.wthdrawLimitOnList = null;
        $scope.loadOnList = null;
        $scope.profitOnList = null;
        $http.get('Charge/InvestorAccountTypeSetting/getTransactionOnDdlList/').
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
        $http.get('/Charge/InvestorAccountTypeSetting/getddlInvestorAccType/').
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
        $http.get('Charge/InvestorAccountTypeSetting/getTransactionOnDdlList/').
          success(function (data) {
              $scope.minimumBalanceOnList = data;
              $scope.wthdrawLimitOnList = data;
              $scope.loadOnList = data;
              $scope.profitOnList = data;
              $scope.loadInvAccTypeSettingById($routeParams.id);
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadAccountTypeForEdit = function () {
        $scope.investorAccountTypeList = null;
        $http.get('/Charge/InvestorAccountTypeSetting/getddlInvestorAccType/').
          success(function (data) {
              $scope.investorAccountTypeList = data;
              $scope.loadTransactionOnForEdit();
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.invAccTypeSetting = {};
    $scope.addInvAccTypeSetting = function () {
        if ($scope.invAccTypeSetting.fldInv) {
            if ($scope.newInvAccTypeSettingForm.$valid) {
                if (isundefinedornullservice.isUndefinedOrNull($scope.invAccTypeSetting.minimum_balance_is_percentage) || $scope.invAccTypeSetting.minimum_balance_is_percentage.toString().trim() == "") {
                    $scope.invAccTypeSetting.minimum_balance_is_percentage = 0;
                }
                if (isundefinedornullservice.isUndefinedOrNull($scope.invAccTypeSetting.withdraw_limit_on) || $scope.invAccTypeSetting.withdraw_limit_on.toString().trim() == "") {
                    $scope.invAccTypeSetting.withdraw_limit_on = 0;
                }
                if (isundefinedornullservice.isUndefinedOrNull($scope.invAccTypeSetting.loan_ratio) || $scope.invAccTypeSetting.loan_ratio.toString().trim() == "") {
                    $scope.invAccTypeSetting.loan_ratio = 0;
                }
                $http({
                    method: 'POST',
                    url: '/Charge/InvestorAccountTypeSetting/AddInvAccTypeSetting',
                    data: $scope.invAccTypeSetting
                }).success(function (data) {
                    if (data.success) {
                        toastr.success("Submitted Successfully");
                        $location.path('/InvestorAccountTypeSettingList');
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
    }

    $scope.loadDropdownsAndInfo = function () {
        $scope.loadAccountTypeForEdit();
    };

    $scope.loadInvAccTypeSettingById = function (id) {
        $http.get('/Charge/InvestorAccountTypeSetting/getInvAccTypeSettingById/' + id).
          success(function (data) {
              if (data.success) {
                  $scope.editInvAccTypeSetting = data.invAccTypeSetting;
                  $scope.getInvestorInfoForEdit();
              }
              else {
                  toastr.error(data.errorMessage);
                  $location.path('/InvestorAccountTypeSettingList');
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
              $location.path('/InvestorAccountTypeSettingList');
          });
    };

    $scope.updateInvAccTypeSetting = function () {
        if ($scope.editInvAccTypeSetting.fldInv) {
            if ($scope.editInvAccTypeSettingForm.$valid) {
                if (isundefinedornullservice.isUndefinedOrNull($scope.editInvAccTypeSetting.minimum_balance_is_percentage) || $scope.editInvAccTypeSetting.minimum_balance_is_percentage.toString().trim() == "") {
                    $scope.editInvAccTypeSetting.minimum_balance_is_percentage = 0;
                }
                if (isundefinedornullservice.isUndefinedOrNull($scope.editInvAccTypeSetting.withdraw_limit_on) || $scope.editInvAccTypeSetting.withdraw_limit_on.toString().trim() == "") {
                    $scope.editInvAccTypeSetting.withdraw_limit_on = 0;
                }
                if (isundefinedornullservice.isUndefinedOrNull($scope.editInvAccTypeSetting.loan_ratio) || $scope.editInvAccTypeSetting.loan_ratio.toString().trim() == "") {
                    $scope.editInvAccTypeSetting.loan_ratio = 0;
                }
                $http({
                    method: 'POST',
                    url: '/Charge/InvestorAccountTypeSetting/UpdateInvAccTypeSetting',
                    data: $scope.editInvAccTypeSetting
                }).success(function (data) {
                    if (data.success) {
                        toastr.success("Submitted Successfully");
                        $location.path('/InvestorAccountTypeSettingList');
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
    }

    $scope.refresh = function () {
        $scope.invAccTypeSetting = {};
    };
})