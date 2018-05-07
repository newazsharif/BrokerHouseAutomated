angular.module('myApp').controller('FundTransferController', function ($scope, $window, $http, $location, $routeParams, $filter, dateconfigservice, dropdownservice, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("--- Fund Transfer");

    $scope.image = '../Images/images.png';
    $scope.signature = '../Images/signature.jpg';

    $scope.open = function ($event, opened) {
        $event.preventDefault();
        $event.stopPropagation();

        $scope[opened] = true;
    };

    $scope.amountInWord = function (amount) {
        $scope.customStyleAmountInWord = {};
        $scope.customStyleAmountInWord.style = { "color": "white", "text-align": "left" };
        $scope.amount_in_word = toWords(amount).toUpperCase() + " TAKA";
    };

    $scope.loadProcessDate = function () {
        $scope.fundTransfer = {};
        $scope.fundTransfer.value_dt = globalvalueservice.getProcessDate();

        $scope.fundTransfer.transfer_dt = globalvalueservice.getProcessDate();

        $scope.transferor_withdraw_limit_on_name = "";

    };

    $scope.setChargeAmountForAdd = function () {
        var amount = 0;
        var charge_rate = parseInt($scope.fundTransfer.transferor_charge_rate);
        var is_charge_percentage = parseInt($scope.fundTransfer.transferor_is_charge_percentage);
        var minimum_charge = parseInt($scope.fundTransfer.transferor_minimum_charge);

        if ($scope.fundTransfer.fldTransferor) {
            if (!isundefinedornullservice.isUndefinedOrNull($scope.fundTransfer.amount) && $scope.fundTransfer.amount.toString().trim() != "" && $scope.fundTransfer.amount.toString().trim() != "0") {
                amount = parseInt($scope.fundTransfer.amount);

                if (charge_rate == 0) {
                    $scope.fundTransfer.charge_amount = 0;
                }
                else if (!is_charge_percentage) {
                    $scope.fundTransfer.charge_amount = charge_rate;
                }
                else if ((amount * charge_rate) / 100 < minimum_charge) {
                    $scope.fundTransfer.charge_amount = minimum_charge;
                }
                else {
                    $scope.fundTransfer.charge_amount = (amount * charge_rate) / 100;
                }
            }
            else {
                $scope.fundTransfer.charge_amount = 0;
            }
        }
    };

    $scope.setChargeAmountForEdit = function () {
        var amount = 0;
        var charge_rate = parseInt($scope.editFndTransfer.transferor_charge_rate);
        var is_charge_percentage = parseInt($scope.editFndTransfer.transferor_is_charge_percentage);
        var minimum_charge = parseInt($scope.editFndTransfer.transferor_minimum_charge);

        if ($scope.editFndTransfer.fldTransferor) {
            if (!isundefinedornullservice.isUndefinedOrNull($scope.editFndTransfer.amount) && $scope.editFndTransfer.amount.toString().trim() != "" && $scope.editFndTransfer.amount.toString().trim() != "0") {
                amount = parseInt($scope.editFndTransfer.amount);

                if (charge_rate == 0) {
                    $scope.editFndTransfer.charge_amount = 0;
                }
                else if (!is_charge_percentage) {
                    $scope.editFndTransfer.charge_amount = charge_rate;
                }
                else if ((amount * charge_rate) / 100 < minimum_charge) {
                    $scope.editFndTransfer.charge_amount = minimum_charge;
                }
                else {
                    $scope.editFndTransfer.charge_amount = (amount * charge_rate) / 100;
                }
            }
            else {
                $scope.editFndTransfer.charge_amount = 0;
            }
        }
    };

    $scope.getTransferorInfoForAdd = function () {
        $scope.customStyle = {};
        var client_id = $scope.fundTransfer.transferor_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Transaction/FundTransfer/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.fundTransfer.transferor_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.fundTransfer.transferor_invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fundTransfer.transferor_invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.fundTransfer.transferor_invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fundTransfer.transferor_invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.fundTransfer.transferor_invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fundTransfer.transferor_invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.fundTransfer.transferor_invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fundTransfer.transferor_invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.fundTransfer.transferor_name += " and " + data.investor.join_holder_name;
                  }

                  if (angular.uppercase(data.investor.withdraw_limit_on_name) == "LEDGER BALANCE") {
                      $scope.fundTransfer.transferor_balance = data.investor.ledger_balance;
                  }
                  else {
                      $scope.fundTransfer.transferor_balance = data.investor.available_balance;
                  }

                  $scope.fundTransfer.transferor_available_balance = data.investor.available_balance;
                  $scope.fundTransfer.transferor_ledger_balance = data.investor.ledger_balance;
                  $scope.fundTransfer.transferor_purchase_power = data.investor.purchase_power;
                  $scope.fundTransfer.transferor_withdrawable_amount = data.investor.withdrawable_amount;
                  $scope.transferor_withdraw_limit_on_name = data.investor.withdraw_limit_on_name;
                  $scope.fundTransfer.transferor_active_status_id = data.investor.active_status_id;
                  $scope.fundTransfer.transferor_charge_rate = data.investor.charge_rate;
                  $scope.fundTransfer.transferor_is_charge_percentage = data.investor.is_charge_percentage;
                  $scope.fundTransfer.transferor_minimum_charge = data.investor.minimum_charge;
                  $scope.fundTransfer.fldTransferor = true;
                  $scope.setChargeAmountForAdd();
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.fundTransfer.transferor_name = data.errorMessage;
                  $scope.fundTransfer.fldTransferor = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.fundTransfer.transferor_name = "";
              $scope.fundTransfer.fldTransferor = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.getTransfereeInfoForAdd = function () {
        $scope.customStyle = {};
        var client_id = $scope.fundTransfer.tranferee_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Transaction/FundTransfer/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.fundTransfer.transferee_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.fundTransfer.transferee_invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fundTransfer.transferee_invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.fundTransfer.transferee_invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fundTransfer.transferee_invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.fundTransfer.transferee_invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fundTransfer.transferee_invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.fundTransfer.transferee_invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fundTransfer.transferee_invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.fundTransfer.transferee_name += " and " + data.investor.join_holder_name;
                  }

                  $scope.fundTransfer.transferee_balance = data.investor.available_balance;

                  $scope.fundTransfer.transferee_available_balance = data.investor.available_balance;
                  $scope.fundTransfer.transferee_ledger_balance = data.investor.ledger_balance;
                  $scope.fundTransfer.transferee_purchase_power = data.investor.purchase_power;
                  $scope.fundTransfer.transferee_active_status_id = data.investor.active_status_id;
                  $scope.fundTransfer.fldTransferee = true;
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.fundTransfer.transferee_name = data.errorMessage;
                  $scope.fundTransfer.fldTransferee = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.fundTransfer.transferee_name = "";
              $scope.fundTransfer.fldTransferee = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.getTransferorInfoForEdit = function () {
        $scope.customStyle = {};
        var client_id = $scope.editFndTransfer.transferor_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Transaction/FundTransfer/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.editFndTransfer.transferor_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.editFndTransfer.transferor_invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editFndTransfer.transferor_invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.editFndTransfer.transferor_invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editFndTransfer.transferor_invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.editFndTransfer.transferor_invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editFndTransfer.transferor_invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.editFndTransfer.transferor_invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editFndTransfer.transferor_invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.editFndTransfer.transferor_name += " and " + data.investor.join_holder_name;
                  }

                  if (angular.uppercase(data.investor.withdraw_limit_on_name) == "LEDGER BALANCE") {
                      $scope.editFndTransfer.transferor_balance = data.investor.ledger_balance;
                  }
                  else {
                      $scope.editFndTransfer.transferor_balance = data.investor.available_balance;
                  }

                  $scope.editFndTransfer.transferor_available_balance = data.investor.available_balance;
                  $scope.editFndTransfer.transferor_ledger_balance = data.investor.ledger_balance;
                  $scope.editFndTransfer.transferor_purchase_power = data.investor.purchase_power;
                  $scope.editFndTransfer.transferor_withdrawable_amount = data.investor.withdrawable_amount;
                  $scope.transferor_withdraw_limit_on_name = data.investor.withdraw_limit_on_name;
                  $scope.editFndTransfer.transferor_active_status_id = data.investor.active_status_id;
                  $scope.editFndTransfer.transferor_charge_rate = data.investor.charge_rate;
                  $scope.editFndTransfer.transferor_is_charge_percentage = data.investor.is_charge_percentage;
                  $scope.editFndTransfer.transferor_minimum_charge = data.investor.minimum_charge;
                  $scope.editFndTransfer.fldTransferor = true;
                  $scope.setChargeAmountForEdit();
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.editFndTransfer.transferor_name = data.errorMessage;
                  $scope.editFndTransfer.fldTransferor = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.editFndTransfer.transferor_name = "";
              $scope.editFndTransfer.fldTransferor = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.getTransfereeInfoForEdit = function () {
        $scope.customStyle = {};
        var client_id = $scope.editFndTransfer.tranferee_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Transaction/FundTransfer/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.editFndTransfer.transferee_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.editFndTransfer.transferee_invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editFndTransfer.transferee_invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.editFndTransfer.transferee_invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editFndTransfer.transferee_invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.editFndTransfer.transferee_invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editFndTransfer.transferee_invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.editFndTransfer.transferee_invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editFndTransfer.transferee_invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.editFndTransfer.transferee_name += " and " + data.investor.join_holder_name;
                  }

                  $scope.editFndTransfer.transferee_balance = data.investor.available_balance;

                  $scope.editFndTransfer.transferee_available_balance = data.investor.available_balance;
                  $scope.editFndTransfer.transferee_ledger_balance = data.investor.ledger_balance;
                  $scope.editFndTransfer.transferee_purchase_power = data.investor.purchase_power;
                  $scope.editFndTransfer.transferee_active_status_id = data.investor.active_status_id;
                  $scope.editFndTransfer.fldTransferee = true;
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.editFndTransfer.transferee_name = data.errorMessage;
                  $scope.editFndTransfer.fldTransferee = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.editFndTransfer.transferee_name = "";
              $scope.editFndTransfer.fldTransferee = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.fundTransfer = {};
    $scope.saveNewFundTransfer = function () {
        if ($scope.fundTransfer.fldTransferor && $scope.fundTransfer.fldTransferee) {
            if ($scope.newFndTransferForm.$valid) {

                if (angular.uppercase($scope.transferor_withdraw_limit_on_name) != "NOT APPLICABLE" && parseInt($scope.fundTransfer.transferor_withdrawable_amount) < (parseInt($scope.fundTransfer.amount) + parseInt($scope.fundTransfer.charge_amount))) {
                    toastr.error("This Investor does not have enough balance to transfer " + $scope.fundTransfer.transferor_withdrawable_amount + " amount with charge " + $scope.fundTransfer.charge_amount + " !!!!!");
                }
                else {
                    var datefilter = $filter('date');

                    var transferDate = $scope.fundTransfer.transfer_dt;

                    var valueDate = datefilter($scope.fundTransfer.value_dt, 'dd/MM/yyyy');

                    $scope.fundTransfer.transfer_date = dateconfigservice.FullDateUKtoDateKey(transferDate);

                    $scope.fundTransfer.value_date = dateconfigservice.FullDateUKtoDateKey(valueDate);

                    $http.get('/Transaction/FundTransfer/getPrevUnapprovedFndTransferByClientId/' + $scope.fundTransfer.transferor_id).
                      success(function (data) {
                          if (data.success) {
                              var isProcess = confirm(data.msg);
                              if (isProcess == true) {
                                  $http({
                                      method: 'POST',
                                      url: '/Transaction/FundTransfer/addFundTransfer',
                                      data: $scope.fundTransfer
                                  }).success(function (data) {
                                      if (data.success) {
                                          $scope.refresh();
                                          toastr.success("Submitted Successfully.");
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
                          else {
                              $http({
                                  method: 'POST',
                                  url: '/Transaction/FundTransfer/addFundTransfer',
                                  data: $scope.fundTransfer
                              }).success(function (data) {
                                  if (data.success) {
                                      $scope.refresh();
                                      toastr.success("Submitted Successfully.");
                                  }
                                  else {
                                      toastr.error(data.errorMessage);
                                  }
                              }).
                            error(function (XMLHttpRequest, textStatus, errorThrown) {
                                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
                            });
                          }
                      }).
                      error(function (XMLHttpRequest, textStatus, errorThrown) {
                          toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
                      });
                }
            }
        }
    };

    $scope.loadFndTransferList = function () {
        $http.get('/Transaction/FundTransfer/getFndTransferList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.fundTransferList;
                  $scope.displayedCollection = [].concat($scope.rowCollection);

                  $scope.totalAmount = 0;
                  for (var i = 0; i < $scope.displayedCollection.length; i++) {
                      $scope.totalAmount += $scope.displayedCollection[i].amount;
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

    $scope.DeleteFundTransfer = function (row) {
        var isDelete = confirm("Are you sure you want to delete this transfer!");
        if (isDelete == true) {
            $http({
                method: 'POST',
                url: '/Transaction/FundTransfer/deleteFundTransfer',
                data: { id: row.id }
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Deleted Successfully");

                    var index = $scope.rowCollection.indexOf(row);
                    if (index !== -1) {
                        $scope.rowCollection.splice(index, 1);
                        $scope.totalAmount = $scope.totalAmount - row.amount;
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

    $scope.loadFndTransferAndDdlById = function () {

        $scope.transferor_withdraw_limit_on_name = "";

        $scope.loadFndTransferById($routeParams.id);
    };

    $scope.loadFndTransferById = function (id) {
        $http.get('/Transaction/FundTransfer/getFndTransferById/' + id).
          success(function (data) {
              if (data.success) {
                  $scope.editFndTransfer = data.editFndTransfer;

                  $scope.getTransferorInfoForEdit();
                  $scope.getTransfereeInfoForEdit();
                  $scope.amountInWord($scope.editFndTransfer.amount);
              }
              else {
                  toastr.error(data.errorMessage);
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.editFundTransfer = function () {
        if ($scope.editFndTransfer.fldTransferor && $scope.editFndTransfer.fldTransferee) {
            if ($scope.editFndTransferForm.$valid) {

                if (angular.uppercase($scope.transferor_withdraw_limit_on_name) != "NOT APPLICABLE" && parseInt($scope.editFndTransfer.transferor_withdrawable_amount) < (parseInt($scope.editFndTransfer.amount) + parseInt($scope.editFndTransfer.charge_amount))) {
                    toastr.error("This Investor does not have enough balance to transfer " + $scope.editFndTransfer.transferor_withdrawable_amount + " amount with charge " + $scope.editFndTransfer.charge_amount + " !!!!!");
                }
                else {
                    var datefilter = $filter('date');

                    var transferDate = $scope.editFndTransfer.transfer_dt;

                    var valueDate = datefilter($scope.editFndTransfer.value_dt, 'dd/MM/yyyy');

                    $scope.editFndTransfer.transfer_date = dateconfigservice.FullDateUKtoDateKey(transferDate);

                    $scope.editFndTransfer.value_date = dateconfigservice.FullDateUKtoDateKey(valueDate);

                    $http({
                        method: 'POST',
                        url: '/Transaction/FundTransfer/updateFundTransfer',
                        data: $scope.editFndTransfer
                    }).success(function (data) {
                        if (data.success) {
                            toastr.success("Submitted Successfully");
                            $location.path('/FundTransferList');
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
    };

    $scope.refresh = function () {

        $scope.fundTransfer = {};

        $scope.fundTransfer.value_dt = globalvalueservice.getProcessDate();

        $scope.fundTransfer.transfer_dt = globalvalueservice.getProcessDate();

        $scope.transferor_withdraw_limit_on_name = "";
    };
})