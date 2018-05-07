angular.module('myApp').controller('FundWithdrawalRequestController', function ($scope, $window, $http, $location, $routeParams, $filter, dateconfigservice, dropdownservice, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("--- Fund Withdrawal Request");

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
        $scope.fndWithdrawalReq = {};
        $scope.fndWithdrawalReq.effective_dt = globalvalueservice.getProcessDate();

        $scope.fndWithdrawalReq.request_dt = globalvalueservice.getProcessDate();

        $scope.fndWithdrawalReq.voucher_no = "Auto";

        $scope.loadTransactionMode();
        $scope.loadBrokerBankAccount();
        $scope.loadBank();
        $scope.loadBranch();
        $scope.getPrevVouchNo();
    };

    $scope.loadTransactionMode = function () {
        $scope.transactionModeList = null;
        $http.get('/Transaction/FundWithdrawalRequest/getTransactionModeDdlList/').
          success(function (data) {
              $scope.transactionModeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadBrokerBankAccount = function () {
        $scope.brokerBankAccountList = null;
        $http.get('/Transaction/FundWithdrawalRequest/getBrokerBankAccountDdlList/').
          success(function (data) {
              $scope.brokerBankAccountList = data;
              //$scope.fndWithdrawalReq.bank_branch_id = data[0].value;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadBrokerBankAccountForEdit = function () {
        $scope.brokerBankAccountList = null;
        $http.get('/Transaction/FundWithdrawalRequest/getBrokerBankAccountDdlList/').
          success(function (data) {
              $scope.brokerBankAccountList = data;
              $scope.editFndWithdrawalReq.bank_branch_id = data[0].value;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadTransactionModeForEdit = function () {
        $scope.transactionModeList = null;
        $http.get('/Transaction/FundWithdrawalRequest/getTransactionModeDdlList/').
          success(function (data) {
              $scope.transactionModeList = data;
              $scope.loadFndWithdrawalReqById($routeParams.id);
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadBank = function () {
        $scope.bankList = null;
        $http.get('/Transaction/FundWithdrawalRequest/getBankDdlList/').
          success(function (data) {
              $scope.bankList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.LoadBankBranch = function (bank_id) {
        $scope.bankBranchList = null;
        if (bank_id != null) {
            $http.get('/Transaction/FundWithdrawalRequest/getBankBranchDdlList?id=' + bank_id)
            .success(function (data) {
                $scope.bankBranchList = data;
            })
            .error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
        }
    };

    $scope.LoadBankBranchForEdit = function (bank_id, editFndWithdrawalReqData) {
        $scope.bankBranchList = null;
        if (bank_id != null) {
            $http.get('/Transaction/FundWithdrawalRequest/getBankBranchDdlList?id=' + bank_id)
            .success(function (data) {
                $scope.bankBranchList = data;
                $scope.editFndWithdrawalReq = editFndWithdrawalReqData.editFndWithdrawalReq;
                $scope.getInvestorInfoForEdit();
                $scope.showHideBankInfoForEdit();
            })
            .error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
        }
    };

    $scope.loadBranch = function () {
        $scope.branchList = null;
        $http.get('/Transaction/FundWithdrawalRequest/getBranchDdlList/').
          success(function (data) {
              $scope.branchList = data;
              $scope.fndWithdrawalReq.broker_branch_id = data[0].value;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.getPrevVouchNo = function () {
        $http.get('/Transaction/FundWithdrawalRequest/getPrevVouchNo/').
          success(function (data) {
              $scope.fndWithdrawalReq.prev_voucher_no = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.getInvestorInfoForAdd = function () {
        $scope.customStyle = {};
        var client_id = $scope.fndWithdrawalReq.client_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Transaction/FundWithdrawalRequest/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.fndWithdrawalReq.first_holder_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.fndWithdrawalReq.invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fndWithdrawalReq.invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.fndWithdrawalReq.invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fndWithdrawalReq.invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.fndWithdrawalReq.invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fndWithdrawalReq.invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.fndWithdrawalReq.invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.fndWithdrawalReq.invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.fndWithdrawalReq.first_holder_name += " and " + data.investor.join_holder_name;
                  }

                  $scope.fndWithdrawalReq.available_balance = data.investor.available_balance;
                  $scope.fndWithdrawalReq.ledger_balance = data.investor.ledger_balance;
                  $scope.fndWithdrawalReq.active_status_id = data.investor.active_status_id;
                  $scope.fndWithdrawalReq.fldInv = true;
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.fndWithdrawalReq.first_holder_name = data.errorMessage;
                  $scope.fndWithdrawalReq.fldInv = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.fndWithdrawalReq.first_holder_name = "";
              $scope.fndWithdrawalReq.fldInv = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.getInvestorInfoForEdit = function () {
        $scope.customStyle = {};
        var client_id = $scope.editFndWithdrawalReq.client_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Transaction/FundWithdrawalRequest/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.editFndWithdrawalReq.first_holder_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.editFndWithdrawalReq.invPic = new Blob([imgByteArray], { type: 'image' });
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.editFndWithdrawalReq.invSignature = new Blob([sigByteArray], { type: 'image' });
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.editFndWithdrawalReq.invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editFndWithdrawalReq.invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.editFndWithdrawalReq.invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editFndWithdrawalReq.invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.editFndWithdrawalReq.first_holder_name += " and " + data.investor.join_holder_name;
                  }

                  $scope.editFndWithdrawalReq.available_balance = data.investor.available_balance;
                  $scope.editFndWithdrawalReq.ledger_balance = data.investor.ledger_balance;
                  $scope.editFndWithdrawalReq.active_status_id = data.investor.active_status_id;
                  $scope.editFndWithdrawalReq.fldInv = true;
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.editFndWithdrawalReq.first_holder_name = data.errorMessage;
                  $scope.editFndWithdrawalReq.fldInv = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.editFndWithdrawalReq.first_holder_name = "";
              $scope.editFndWithdrawalReq.fldInv = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.showHideBankInfoForAdd = function () {
        if (isundefinedornullservice.isUndefinedOrNull($scope.fndWithdrawalReq.transaction_mode_id)) {
            $scope.fndWithdrawalReq.cheque_dt = "";
            $scope.fndWithdrawalReq.cheque_no = "";
            $scope.fndWithdrawalReq.bank_id = "";
            $scope.fndWithdrawalReq.bank_branch_id = "";
            $scope.fndWithdrawalReq.fldBank = false;
        }
        else {
            var transactionModeName = dropdownservice.getSelectedText($scope.transactionModeList, $scope.fndWithdrawalReq.transaction_mode_id);
            if (transactionModeName != "CS") {
                $scope.fndWithdrawalReq.fldBank = true;
                $scope.fndWithdrawalReq.cheque_dt = globalvalueservice.getProcessDate();
            }
            else {
                $scope.fndWithdrawalReq.cheque_dt = "";
                $scope.fndWithdrawalReq.cheque_no = "";
                $scope.fndWithdrawalReq.bank_id = "";
                $scope.fndWithdrawalReq.bank_branch_id = "";
                $scope.fndWithdrawalReq.fldBank = false;
            }
        }
    };

    $scope.showHideBankInfoForEdit = function () {
        if (isundefinedornullservice.isUndefinedOrNull($scope.editFndWithdrawalReq.transaction_mode_id)) {
            $scope.editFndWithdrawalReq.cheque_dt = "";
            $scope.editFndWithdrawalReq.cheque_no = "";
            $scope.editFndWithdrawalReq.bank_id = "";
            $scope.editFndWithdrawalReq.bank_branch_id = "";
            $scope.editFndWithdrawalReq.fldBank = false;
        }
        else {
            var transactionModeName = dropdownservice.getSelectedText($scope.transactionModeList, $scope.editFndWithdrawalReq.transaction_mode_id);
            if (transactionModeName != "CS") {
                $scope.editFndWithdrawalReq.fldBank = true;
                if (isundefinedornullservice.isUndefinedOrNull($scope.editFndWithdrawalReq.cheque_dt) || $scope.editFndWithdrawalReq.cheque_dt == null || $scope.editFndWithdrawalReq.cheque_dt.toString().trim() == "") {
                    $scope.editFndWithdrawalReq.cheque_dt = globalvalueservice.getProcessDate();
                }
            }
            else {
                $scope.editFndWithdrawalReq.cheque_dt = "";
                $scope.editFndWithdrawalReq.cheque_no = "";
                $scope.editFndWithdrawalReq.bank_id = "";
                $scope.editFndWithdrawalReq.bank_branch_id = "";
                $scope.editFndWithdrawalReq.fldBank = false;
            }
        }
    };

    $scope.fndWithdrawalReq = {};
    $scope.saveNewFndWithdrawalReq = function () {
        if ($scope.fndWithdrawalReq.fldInv) {
            if ($scope.newFndWithdrawalReqForm.$valid) {

                var transactionModeName = dropdownservice.getSelectedText($scope.transactionModeList, $scope.fndWithdrawalReq.transaction_mode_id);

                var chequeDate = $scope.fndWithdrawalReq.cheque_dt;

                if (transactionModeName != "CS" && transactionModeName != "ET") {
                    var chequeNo = $scope.fndWithdrawalReq.cheque_no;
                    var bank = $scope.fndWithdrawalReq.bank_branch_id;
                   // var bankBranch = $scope.fndWithdrawalReq.bank_branch_id;

                    if (isundefinedornullservice.isUndefinedOrNull(chequeDate) || chequeDate.toString().trim() == "") {
                        toastr.error("Please insert cheque date!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(chequeNo) || chequeNo.toString().trim() == "") {
                        toastr.error("Please insert cheque no!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(bank) || bank.toString().trim() == "") {
                        toastr.error("Please select a bank!!!!!");
                    }
                    //else if (isundefinedornullservice.isUndefinedOrNull(bankBranch) || bankBranch.toString().trim() == "") {
                    //    toastr.error("Please select bank branch!!!!!");
                    //}
                    else {
                        var datefilter = $filter('date');

                        var requestDate = $scope.fndWithdrawalReq.request_dt;

                        var effectiveDate = datefilter($scope.fndWithdrawalReq.effective_dt, 'dd/MM/yyyy');

                        $scope.fndWithdrawalReq.request_date = dateconfigservice.FullDateUKtoDateKey(requestDate);

                        $scope.fndWithdrawalReq.effective_date = dateconfigservice.FullDateUKtoDateKey(effectiveDate);

                        if (!isundefinedornullservice.isUndefinedOrNull(chequeDate) && chequeDate.toString().trim() != "") {
                            chequeDate = datefilter($scope.fndWithdrawalReq.cheque_dt, 'dd/MM/yyyy');
                            $scope.fndWithdrawalReq.cheque_date = dateconfigservice.FullDateUKtoDateKey(chequeDate);
                        }

                        if (parseInt($scope.fndWithdrawalReq.effective_date) <= parseInt($scope.fndWithdrawalReq.request_date)) {
                            toastr.error("Effective Date must be greater than Request Date!!!");
                        }
                        else {
                            $http.get('/Transaction/FundWithdrawalRequest/getPrevUnapprovedFndWithRecByClientId/' + $scope.fndWithdrawalReq.client_id).
                              success(function (data) {
                                  if (data.success) {
                                      var isProcess = confirm(data.msg);
                                      if (isProcess == true) {
                                          $http({
                                              method: 'POST',
                                              url: '/Transaction/FundWithdrawalRequest/addFndWithdrawalReq',
                                              data: $scope.fndWithdrawalReq
                                          }).success(function (data) {
                                              if (data.success) {
                                                  $scope.refresh();
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
                                          url: '/Transaction/FundWithdrawalRequest/addFndWithdrawalReq',
                                          data: $scope.fndWithdrawalReq
                                      }).success(function (data) {
                                          if (data.success) {
                                              $scope.refresh();
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
                else {
                    var datefilter = $filter('date');

                    var requestDate = $scope.fndWithdrawalReq.request_dt;

                    var effectiveDate = datefilter($scope.fndWithdrawalReq.effective_dt, 'dd/MM/yyyy');

                    $scope.fndWithdrawalReq.request_date = dateconfigservice.FullDateUKtoDateKey(requestDate);

                    $scope.fndWithdrawalReq.effective_date = dateconfigservice.FullDateUKtoDateKey(effectiveDate);

                    if (isundefinedornullservice.isUndefinedOrNull(chequeDate) && chequeDate.toString().trim() != "") {
                        chequeDate = datefilter($scope.fndWithdrawalReq.cheque_dt, 'dd/MM/yyyy');
                        $scope.fndWithdrawalReq.cheque_date = dateconfigservice.FullDateUKtoDateKey(chequeDate);
                    }

                    if (parseInt($scope.fndWithdrawalReq.effective_date) <= parseInt($scope.fndWithdrawalReq.request_date)) {
                        toastr.error("Effective Date must be greater than Request Date!!!");
                    }
                    else {
                        $http.get('/Transaction/FundWithdrawalRequest/getPrevUnapprovedFndWithRecByClientId/' + $scope.fndWithdrawalReq.client_id).
                          success(function (data) {
                              if (data.success) {
                                  var isProcess = confirm(data.msg);
                                  if (isProcess == true) {
                                      $http({
                                          method: 'POST',
                                          url: '/Transaction/FundWithdrawalRequest/addFndWithdrawalReq',
                                          data: $scope.fndWithdrawalReq
                                      }).success(function (data) {
                                          if (data.success) {
                                              $scope.refresh();
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
                                      url: '/Transaction/FundWithdrawalRequest/addFndWithdrawalReq',
                                      data: $scope.fndWithdrawalReq
                                  }).success(function (data) {
                                      if (data.success) {
                                          $scope.refresh();
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

    $scope.loadFndWithdrawalReqList = function () {
        $http.get('/Transaction/FundWithdrawalRequest/getFndWithdrawalReqList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.fndWithdrawalReqList;
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

    $scope.DeleteFndWithdrawalReq = function (row) {
        var isDelete = confirm("Are you sure you want to delete this payment!");
        if (isDelete == true) {
            $http({
                method: 'POST',
                url: '/Transaction/FundWithdrawalRequest/deleteFndWithdrawalReq',
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

    $scope.loadFndWithdrawalReqAndDdlById = function () {
        $scope.loadBank();
        $scope.loadBranch();
        $scope.loadTransactionModeForEdit();
        $scope.loadBrokerBankAccountForEdit();

    };

    $scope.loadFndWithdrawalReqById = function (id) {
        $http.get('/Transaction/FundWithdrawalRequest/getFndWithdrawalReqById/' + id).
          success(function (data) {
              if (data.success) {
                  var transactionModeName = dropdownservice.getSelectedText($scope.transactionModeList, data.editFndWithdrawalReq.transaction_mode_id);
                  if (transactionModeName != "CS") {
                      $scope.LoadBankBranchForEdit(data.editFndWithdrawalReq.bank_id, data);
                      $scope.amountInWord($scope.editFndWithdrawalReq.amount);
                  }
                  else {
                      $scope.editFndWithdrawalReq = data.editFndWithdrawalReq;
                      $scope.getInvestorInfoForEdit();
                      $scope.showHideBankInfoForEdit();
                      $scope.amountInWord($scope.editFndWithdrawalReq.amount);
                     // $scope.loadBrokerBankAccountForEdit();
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

    $scope.editFundWithdrawalRequest = function () {
        if ($scope.editFndWithdrawalReq.fldInv) {
            if ($scope.editFndWithdrawalReqForm.$valid) {

                var transactionModeName = dropdownservice.getSelectedText($scope.transactionModeList, $scope.editFndWithdrawalReq.transaction_mode_id);

                var chequeDate = $scope.editFndWithdrawalReq.cheque_dt;

                if (transactionModeName != "CS" && transactionModeName != "ET") {
                    var chequeNo = $scope.editFndWithdrawalReq.cheque_no;
                    var bank = $scope.editFndWithdrawalReq.bank_id;
                    var bankBranch = $scope.editFndWithdrawalReq.bank_branch_id;

                    if (isundefinedornullservice.isUndefinedOrNull(chequeDate) || chequeDate.toString().trim() == "") {
                        toastr.error("Please insert cheque date!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(chequeNo) || chequeNo.toString().trim() == "") {
                        toastr.error("Please insert cheque no!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(bank) || bank.toString().trim() == "") {
                        toastr.error("Please select a bank!!!!!");
                    }
                    //else if (isundefinedornullservice.isUndefinedOrNull(bankBranch) || bankBranch.toString().trim() == "") {
                    //    toastr.error("Please select a bank branch!!!!!");
                    //}
                    else {
                        var datefilter = $filter('date');

                        var requestDate = $scope.editFndWithdrawalReq.request_dt;

                        var effectiveDate = datefilter($scope.editFndWithdrawalReq.effective_dt, 'dd/MM/yyyy');

                        $scope.editFndWithdrawalReq.request_date = dateconfigservice.FullDateUKtoDateKey(requestDate);

                        $scope.editFndWithdrawalReq.effective_date = dateconfigservice.FullDateUKtoDateKey(effectiveDate);

                        if (!isundefinedornullservice.isUndefinedOrNull(chequeDate) && chequeDate.toString().trim() != "") {
                            chequeDate = datefilter($scope.editFndWithdrawalReq.cheque_dt, 'dd/MM/yyyy');
                            $scope.editFndWithdrawalReq.cheque_date = dateconfigservice.FullDateUKtoDateKey(chequeDate);
                        }

                        if (parseInt($scope.editFndWithdrawalReq.effective_date) <= parseInt($scope.editFndWithdrawalReq.request_date)) {
                            toastr.error("Effective Date must be greater than Request Date!!!");
                        }
                        else {
                            $http({
                                method: 'POST',
                                url: '/Transaction/FundWithdrawalRequest/updateFndWithdrawalReq',
                                data: $scope.editFndWithdrawalReq
                            }).success(function (data) {
                                if (data.success) {
                                    toastr.success("Submitted Successfully");
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
                else {
                    var datefilter = $filter('date');

                    var requestDate = $scope.editFndWithdrawalReq.request_dt;

                    var effectiveDate = datefilter($scope.editFndWithdrawalReq.effective_dt, 'dd/MM/yyyy');

                    $scope.editFndWithdrawalReq.request_date = dateconfigservice.FullDateUKtoDateKey(requestDate);

                    $scope.editFndWithdrawalReq.effective_date = dateconfigservice.FullDateUKtoDateKey(effectiveDate);

                    if (!isundefinedornullservice.isUndefinedOrNull(chequeDate) && chequeDate.toString().trim() != "") {
                        chequeDate = datefilter($scope.editFndWithdrawalReq.cheque_dt, 'dd/MM/yyyy');
                        $scope.editFndWithdrawalReq.cheque_date = dateconfigservice.FullDateUKtoDateKey(chequeDate);
                    }

                    if (parseInt($scope.editFndWithdrawalReq.effective_date) <= parseInt($scope.editFndWithdrawalReq.request_date)) {
                        toastr.error("Effective Date must be greater than Request Date!!!");
                    }
                    else {
                        $http({
                            method: 'POST',
                            url: '/Transaction/FundWithdrawalRequest/updateFndWithdrawalReq',
                            data: $scope.editFndWithdrawalReq
                        }).success(function (data) {
                            if (data.success) {
                                toastr.success("Submitted Successfully");
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
        $scope.fndWithdrawalReq = {};

        $scope.amount_in_word = "";

        $scope.fndWithdrawalReq.effective_dt = globalvalueservice.getProcessDate();

        $scope.fndWithdrawalReq.request_dt = globalvalueservice.getProcessDate();

        $scope.fndWithdrawalReq.voucher_no = "Auto";
        $scope.loadBranch();
        $scope.getPrevVouchNo();
        $scope.showHideBankInfoForAdd();
    };
})