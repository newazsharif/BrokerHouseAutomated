angular.module('myApp').controller('FundPaymentController', function ($scope, $window, $http, $location, $routeParams, $filter, dateconfigservice, dropdownservice, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("--- Fund Payment");

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

    $scope.loadDropdowns = function () {
        $scope.fundPayment = {};
        $scope.fundPayment.value_dt = globalvalueservice.getProcessDate();

        $scope.fundPayment.payment_dt = globalvalueservice.getProcessDate();

        $scope.fundPayment.voucher_no = "Auto";

        $scope.loadTransactionMode();
        $scope.loadBrokerBankAccount();
        $scope.loadBranch();
        $scope.getPrevVouchNo();

        $scope.getBalanceCheckType();

        $scope.withdraw_limit_on_name = "";

    };

    $scope.getBalanceCheckType = function () {
        $http.get('/Transaction/FundPayment/getBalanceCheckType').
          success(function (data) {
              if (data.success) {
                  $scope.balance_check_type = data.balance_check_type;
              }
              else {
                  toastr.error(data.errorMessage);
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    }

    $scope.loadTransactionMode = function () {
        $scope.transactionModeList = null;
        $http.get('/Transaction/FundPayment/getTransactionModeDdlList/').
          success(function (data) {
              $scope.transactionModeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadTransactionModeForEdit = function () {
        $scope.transactionModeList = null;
        $http.get('/Transaction/FundPayment/getTransactionModeDdlList/').
          success(function (data) {
              $scope.transactionModeList = data;
              $scope.loadFndPaymentById($routeParams.id);
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadBrokerBankAccount = function () {
        $scope.brokerBankAccountList = null;
        $http.get('/Transaction/FundPayment/getBrokerBankAccountDdlList/').
          success(function (data) {
              $scope.brokerBankAccountList = data;
              $scope.fundPayment.bank_branch_id = data[0].value;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadBrokerBankAccountForEdit = function () {
        $scope.brokerBankAccountList = null;
        $http.get('/Transaction/FundPayment/getBrokerBankAccountDdlList/').
          success(function (data) {
              $scope.brokerBankAccountList = data;
              $scope.editFndPayment.bank_branch_id = data[0].value;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadBranch = function () {
        $scope.branchList = null;
        $http.get('/Transaction/FundPayment/getBranchDdlList/').
          success(function (data) {
              $scope.branchList = data;
              $scope.fundPayment.broker_branch_id = data[0].value;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadBranchForEdit = function () {
        $scope.branchList = null;
        $http.get('/Transaction/FundPayment/getBranchDdlList/').
          success(function (data) {
              $scope.branchList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.getPrevVouchNo = function () {
        $http.get('/Transaction/FundPayment/getPrevVouchNo/').
          success(function (data) {
              $scope.fundPayment.prev_voucher_no = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.getInvestorInfoForAdd = function () {
        $scope.customStyle = {};
        var client_id = $scope.fundPayment.client_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Transaction/FundPayment/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.fundPayment.first_holder_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.fundPayment.invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fundPayment.invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.fundPayment.invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fundPayment.invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.fundPayment.invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fundPayment.invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.fundPayment.invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fundPayment.invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.fundPayment.first_holder_name += " and " + data.investor.join_holder_name;
                  }

                  $scope.fundPayment.available_balance = data.investor.available_balance;
                  $scope.fundPayment.ledger_balance = data.investor.ledger_balance;
                  $scope.fundPayment.purchase_power = data.investor.purchase_power;
                  $scope.fundPayment.withdrawable_amount = data.investor.withdrawable_amount;
                  $scope.fundPayment.active_status_id = data.investor.active_status_id;
                  $scope.withdraw_limit_on_name = data.investor.withdraw_limit_on_name;
                  $scope.fundPayment.fldInv = true;
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.fundPayment.first_holder_name = data.errorMessage;
                  $scope.fundPayment.fldInv = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.fundPayment.first_holder_name = "";
              $scope.fundPayment.fldInv = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.getInvestorInfoForEdit = function () {
        $scope.customStyle = {};
        var client_id = $scope.editFndPayment.client_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Transaction/FundPayment/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.editFndPayment.first_holder_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.editFndPayment.invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editFndPayment.invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.editFndPayment.invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editFndPayment.invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.editFndPayment.invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editFndPayment.invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.editFndPayment.invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editFndPayment.invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.editFndPayment.first_holder_name += " and " + data.investor.join_holder_name;
                  }

                  $scope.editFndPayment.available_balance = data.investor.available_balance;
                  $scope.editFndPayment.ledger_balance = data.investor.ledger_balance;
                  $scope.editFndPayment.purchase_power = data.investor.purchase_power;
                  $scope.editFndPayment.withdrawable_amount = data.investor.withdrawable_amount;
                  $scope.editFndPayment.active_status_id = data.investor.active_status_id;
                  $scope.withdraw_limit_on_name = data.investor.withdraw_limit_on_name;
                  $scope.editFndPayment.fldInv = true;
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.editFndPayment.first_holder_name = data.errorMessage;
                  $scope.editFndPayment.fldInv = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.editFndPayment.first_holder_name = "";
              $scope.editFndPayment.fldInv = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.showHideBankInfoForAdd = function () {
        if (isundefinedornullservice.isUndefinedOrNull($scope.fundPayment.transaction_mode_id)) {
            $scope.fundPayment.cheque_dt = "";
            $scope.fundPayment.cheque_no = "";
            $scope.fundPayment.bank_id = "";
            $scope.fundPayment.bank_branch_id = "";
            $scope.fundPayment.fldBank = false;
        }
        else {
            var transactionModeName = dropdownservice.getSelectedText($scope.transactionModeList, $scope.fundPayment.transaction_mode_id);
            if (transactionModeName != "CS") {
                $scope.fundPayment.fldBank = true;
                $scope.fundPayment.cheque_dt = globalvalueservice.getProcessDate();
            }
            else {
                $scope.fundPayment.cheque_dt = "";
                $scope.fundPayment.cheque_no = "";
                $scope.fundPayment.bank_id = "";
                $scope.fundPayment.bank_branch_id = "";
                $scope.fundPayment.fldBank = false;
            }
        }
    };

    $scope.showHideBankInfoForEdit = function () {
        if (isundefinedornullservice.isUndefinedOrNull($scope.editFndPayment.transaction_mode_id)) {
            $scope.editFndPayment.cheque_dt = "";
            $scope.editFndPayment.cheque_no = "";
            $scope.editFndPayment.bank_id = "";
            $scope.editFndPayment.bank_branch_id = "";
            $scope.editFndPayment.fldBank = false;
        }
        else {
            var transactionModeName = dropdownservice.getSelectedText($scope.transactionModeList, $scope.editFndPayment.transaction_mode_id);
            if (transactionModeName != "CS") {
                $scope.editFndPayment.fldBank = true;
                if (isundefinedornullservice.isUndefinedOrNull($scope.editFndPayment.cheque_dt) || $scope.editFndPayment.cheque_dt == null || $scope.editFndPayment.cheque_dt.toString().trim() == "") {
                    $scope.editFndPayment.cheque_dt = globalvalueservice.getProcessDate();
                }
            }
            else {
                $scope.editFndPayment.cheque_dt = "";
                $scope.editFndPayment.cheque_no = "";
                $scope.editFndPayment.bank_id = "";
                $scope.editFndPayment.bank_branch_id = "";
                $scope.editFndPayment.fldBank = false;
            }
        }
    };

    $scope.fundPayment = {};
    $scope.saveNewFundPayment = function () {
        if ($scope.fundPayment.fldInv) {
            if ($scope.newFndPaymentForm.$valid) {

                var transactionModeName = dropdownservice.getSelectedText($scope.transactionModeList, $scope.fundPayment.transaction_mode_id);

                var chequeDate = $scope.fundPayment.cheque_dt;

                if (transactionModeName != "CS" && transactionModeName != "ET") {
                    var chequeNo = $scope.fundPayment.cheque_no;
                    var bank = $scope.fundPayment.bank_id;
                    var bankBranch = $scope.fundPayment.bank_branch_id;

                    if (isundefinedornullservice.isUndefinedOrNull(chequeDate) || chequeDate.toString().trim() == "") {
                        toastr.error("Please insert cheque date!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(chequeNo) || chequeNo.toString().trim() == "") {
                        toastr.error("Please insert cheque no!!!!!");
                    }
                    else if (angular.uppercase($scope.withdraw_limit_on_name) != "NOT APPLICABLE" && parseInt($scope.fundPayment.withdrawable_amount) < parseInt($scope.fundPayment.amount)) {
                        toastr.error("This Investor does not have enough balance to apply for payment!!!!!");
                    }
                    else {
                        var datefilter = $filter('date');

                        var paymentDate = $scope.fundPayment.payment_dt;

                        var valueDate = datefilter($scope.fundPayment.value_dt, 'dd/MM/yyyy');

                        $scope.fundPayment.withdraw_date = dateconfigservice.FullDateUKtoDateKey(paymentDate);

                        $scope.fundPayment.value_date = dateconfigservice.FullDateUKtoDateKey(valueDate);

                        if (!isundefinedornullservice.isUndefinedOrNull(chequeDate) && chequeDate.toString().trim() != "") {
                            chequeDate = datefilter($scope.fundPayment.cheque_dt, 'dd/MM/yyyy');
                            $scope.fundPayment.cheque_date = dateconfigservice.FullDateUKtoDateKey(chequeDate);
                        }

                        $http.get('/Transaction/FundPayment/getPrevUnapprovedFndPaymentByClientId/' + $scope.fundPayment.client_id).
                          success(function (data) {
                              if (data.success) {
                                  var isProcess = confirm(data.msg);
                                  if (isProcess == true) {
                                      $http({
                                          method: 'POST',
                                          url: '/Transaction/FundPayment/addFundPayment',
                                          data: $scope.fundPayment
                                      }).success(function (data) {
                                          if (data.success) {
                                              $scope.getPrevVouchNo();

                                              $scope.amount_in_word = "";

                                              $scope.fundPayment.first_holder_name = "";

                                              $scope.fundPayment.fldInv = false;

                                              $scope.fundPayment.client_id = "";

                                              $scope.fundPayment.remarks = "";

                                              $scope.fundPayment.amount = "";

                                              $scope.fundPayment.cheque_no = parseInt($scope.fundPayment.cheque_no) + 1;

                                              toastr.success("Submitted Successfully. Voucher No: " + data.voucher_no);
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
                                      url: '/Transaction/FundPayment/addFundPayment',
                                      data: $scope.fundPayment
                                  }).success(function (data) {
                                      if (data.success) {
                                          $scope.getPrevVouchNo();

                                          $scope.amount_in_word = "";

                                          $scope.fundPayment.first_holder_name = "";

                                          $scope.fundPayment.fldInv = false;

                                          $scope.fundPayment.client_id = "";

                                          $scope.fundPayment.remarks = "";

                                          $scope.fundPayment.amount = "";

                                          $scope.fundPayment.cheque_no = parseInt($scope.fundPayment.cheque_no) + 1;

                                          toastr.success("Submitted Successfully. Voucher No: " + data.voucher_no);
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
                else {
                    if (angular.uppercase($scope.withdraw_limit_on_name) != "NOT APPLICABLE" && parseInt($scope.fundPayment.withdrawable_amount) < parseInt($scope.fundPayment.amount)) {
                        toastr.error("This Investor does not have enough balance to apply for payment!!!!!");
                    }
                    else {
                        var datefilter = $filter('date');

                        var paymentDate = $scope.fundPayment.payment_dt;

                        var valueDate = datefilter($scope.fundPayment.value_dt, 'dd/MM/yyyy');

                        $scope.fundPayment.withdraw_date = dateconfigservice.FullDateUKtoDateKey(paymentDate);

                        $scope.fundPayment.value_date = dateconfigservice.FullDateUKtoDateKey(valueDate);

                        if (!isundefinedornullservice.isUndefinedOrNull(chequeDate) && chequeDate.toString().trim() != "") {
                            chequeDate = datefilter($scope.fundPayment.cheque_dt, 'dd/MM/yyyy');
                            $scope.fundPayment.cheque_date = dateconfigservice.FullDateUKtoDateKey(chequeDate);
                        }

                        //$scope.fundPayment.bank_branch_id = null;

                        $http.get('/Transaction/FundPayment/getPrevUnapprovedFndPaymentByClientId/' + $scope.fundPayment.client_id).
                          success(function (data) {
                              if (data.success) {
                                  var isProcess = confirm(data.msg);
                                  if (isProcess == true) {
                                      $http({
                                          method: 'POST',
                                          url: '/Transaction/FundPayment/addFundPayment',
                                          data: $scope.fundPayment
                                      }).success(function (data) {
                                          if (data.success) {
                                              if (transactionModeName === 'ET') {
                                                  $scope.getPrevVouchNo();

                                                  $scope.amount_in_word = "";

                                                  $scope.fundPayment.first_holder_name = "";

                                                  $scope.fundPayment.fldInv = false;

                                                  $scope.fundPayment.client_id = "";

                                                  $scope.fundPayment.remarks = "";

                                                  $scope.fundPayment.amount = "";

                                                  $scope.fundPayment.cheque_no = parseInt($scope.fundPayment.cheque_no) + 1;

                                                  toastr.success("Submitted Successfully. Voucher No: " + data.voucher_no);
                                              } else {
                                                  $scope.refresh();
                                              }
                                              

                                              toastr.success("Submitted Successfully. Voucher No: " + data.voucher_no);
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
                                      url: '/Transaction/FundPayment/addFundPayment',
                                      data: $scope.fundPayment
                                  }).success(function (data) {
                                      if (data.success) {
                                          if (transactionModeName === 'ET') {
                                              $scope.getPrevVouchNo();

                                              $scope.amount_in_word = "";

                                              $scope.fundPayment.first_holder_name = "";

                                              $scope.fundPayment.fldInv = false;

                                              $scope.fundPayment.client_id = "";

                                              $scope.fundPayment.remarks = "";

                                              $scope.fundPayment.amount = "";
                                          } else {
                                              $scope.refresh();
                                          }
                                          //$scope.fundPayment.cheque_no = parseInt($scope.fundPayment.cheque_no) + 1;
                                          

                                          $scope.fundPayment.cheque_no = parseInt($scope.fundPayment.cheque_no) + 1;

                                          toastr.success("Submitted Successfully. Voucher No: " + data.voucher_no);
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
        }
    };

    $scope.loadFndPaymentList = function () {
        $http.get('/Transaction/FundPayment/getFndPaymentList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.fundPaymentList;
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

    $scope.DeleteFundPayment = function (row) {
        var isDelete = confirm("Are you sure you want to delete this payment!");
        if (isDelete == true) {
            $http({
                method: 'POST',
                url: '/Transaction/FundPayment/deleteFundPayment',
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

    $scope.loadFndPaymentAndDdlById = function () {
        $scope.withdraw_limit_on_name = "";

        $scope.loadBranchForEdit();

        $scope.loadTransactionModeForEdit();

        $scope.getBalanceCheckType();
    };

    $scope.loadFndPaymentById = function (id) {
        $http.get('/Transaction/FundPayment/getFndPaymentById/' + id).
          success(function (data) {
              if (data.success) {
                  var transactionModeName = dropdownservice.getSelectedText($scope.transactionModeList, data.editFndPayment.transaction_mode_id);
                  $scope.editFndPayment = data.editFndPayment;
                  if (transactionModeName != "CS") {
                      $scope.getInvestorInfoForEdit();
                      $scope.showHideBankInfoForEdit();
                      $scope.amountInWord($scope.editFndPayment.amount);
                  }
                  else {
                      $scope.getInvestorInfoForEdit();
                      $scope.showHideBankInfoForEdit();
                      $scope.amountInWord($scope.editFndPayment.amount);
                  }
                  $scope.loadBrokerBankAccountForEdit();
              }
              else {
                  toastr.error(data.errorMessage);
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.editFundPayment = function () {
        if ($scope.editFndPayment.fldInv) {
            if ($scope.editFndPaymentForm.$valid) {

                var transactionModeName = dropdownservice.getSelectedText($scope.transactionModeList, $scope.editFndPayment.transaction_mode_id);

                var chequeDate = $scope.editFndPayment.cheque_dt;

                if (transactionModeName != "CS" && transactionModeName != "ET") {
                    var chequeNo = $scope.editFndPayment.cheque_no;
                    var bank = $scope.editFndPayment.bank_id;
                    var bankBranch = $scope.editFndPayment.bank_branch_id;

                    if (isundefinedornullservice.isUndefinedOrNull(chequeDate) || chequeDate.toString().trim() == "") {
                        toastr.error("Please insert cheque date!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(chequeNo) || chequeNo.toString().trim() == "") {
                        toastr.error("Please insert cheque no!!!!!");
                    }
                    else if (angular.uppercase($scope.withdraw_limit_on_name) != "NOT APPLICABLE" && parseInt($scope.editFndPayment.withdrawable_amount) < parseInt($scope.editFndPayment.amount)) {
                        toastr.error("This Investor does not have enough balance to apply for payment!!!!!");
                    }
                    else {
                        var datefilter = $filter('date');

                        var paymentDate = $scope.editFndPayment.payment_dt;

                        var valueDate = datefilter($scope.editFndPayment.value_dt, 'dd/MM/yyyy');

                        $scope.editFndPayment.withdraw_date = dateconfigservice.FullDateUKtoDateKey(paymentDate);

                        $scope.editFndPayment.value_date = dateconfigservice.FullDateUKtoDateKey(valueDate);

                        if (!isundefinedornullservice.isUndefinedOrNull(chequeDate) && chequeDate.toString().trim() != "") {
                            chequeDate = datefilter($scope.editFndPayment.cheque_dt, 'dd/MM/yyyy');
                            $scope.editFndPayment.cheque_date = dateconfigservice.FullDateUKtoDateKey(chequeDate);
                        }

                        $http({
                            method: 'POST',
                            url: '/Transaction/FundPayment/updateFundPayment',
                            data: $scope.editFndPayment
                        }).success(function (data) {
                            if (data.success) {
                                toastr.success("Submitted Successfully");
                                $location.path('/FundPaymentList');
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
                    if (angular.uppercase($scope.withdraw_limit_on_name) != "NOT APPLICABLE" && parseInt($scope.editFndPayment.withdrawable_amount) < parseInt($scope.editFndPayment.amount)) {
                        toastr.error("This Investor does not have enough balance to apply for payment!!!!!");
                    }
                    else {
                        var datefilter = $filter('date');

                        var paymentDate = $scope.editFndPayment.payment_dt;

                        var valueDate = datefilter($scope.editFndPayment.value_dt, 'dd/MM/yyyy');

                        $scope.editFndPayment.withdraw_date = dateconfigservice.FullDateUKtoDateKey(paymentDate);

                        $scope.editFndPayment.value_date = dateconfigservice.FullDateUKtoDateKey(valueDate);

                        if (!isundefinedornullservice.isUndefinedOrNull(chequeDate) && chequeDate.toString().trim() != "") {
                            chequeDate = datefilter($scope.editFndPayment.cheque_dt, 'dd/MM/yyyy');
                            $scope.editFndPayment.cheque_date = dateconfigservice.FullDateUKtoDateKey(chequeDate);
                        }

                        $scope.editFndPayment.bank_branch_id = null;

                        $http({
                            method: 'POST',
                            url: '/Transaction/FundPayment/updateFundPayment',
                            data: $scope.editFndPayment
                        }).success(function (data) {
                            if (data.success) {
                                toastr.success("Submitted Successfully");
                                $location.path('/FundPaymentList');
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
        }
    };

    $scope.refresh = function () {
        $scope.withdraw_limit_on_name = "";

        $scope.fundPayment = {};

        $scope.amount_in_word = "";

        $scope.fundPayment.value_dt = globalvalueservice.getProcessDate();

        $scope.fundPayment.payment_dt = globalvalueservice.getProcessDate();

        $scope.fundPayment.voucher_no = "Auto";
        $scope.loadBrokerBankAccount();
        $scope.loadBranch();
        $scope.getPrevVouchNo();
        $scope.showHideBankInfoForAdd();
    };
})