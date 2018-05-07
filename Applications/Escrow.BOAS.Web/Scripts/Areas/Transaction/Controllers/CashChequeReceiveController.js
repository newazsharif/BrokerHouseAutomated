angular.module('myApp').controller('CashChequeReceiveController', function ($scope, $window, $http, $location, $routeParams, $filter, dateconfigservice, dropdownservice, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("--- Fund Receive");

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
        $scope.cashCheqReceive = {};
        $scope.cashCheqReceive.value_dt = globalvalueservice.getProcessDate();

        $scope.cashCheqReceive.receive_dt = globalvalueservice.getProcessDate();

        $scope.cashCheqReceive.voucher_no = "Auto";

        $scope.loadTransactionMode();
        $scope.loadBank();
        $scope.loadBranch();
        $scope.getPrevVouchNo();
    };

    $scope.loadTransactionMode = function () {
        $scope.transactionModeList = null;
        $http.get('/Transaction/CashChequeReceive/getTransactionModeDdlList/').
          success(function (data) {
              $scope.transactionModeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadTransactionModeForEdit = function () {
        $scope.transactionModeList = null;
        $http.get('/Transaction/CashChequeReceive/getTransactionModeDdlList/').
          success(function (data) {
              $scope.transactionModeList = data;
              $scope.loadCashCheqRecById($routeParams.id);
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadBank = function () {
        $scope.bankList = null;
        $http.get('/Transaction/CashChequeReceive/getBankDdlList/').
          success(function (data) {
              $scope.bankList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadBranch = function () {
        $scope.branchList = null;
        $http.get('/Transaction/CashChequeReceive/getBranchDdlList/').
          success(function (data) {
              $scope.branchList = data;
              $scope.cashCheqReceive.broker_branch_id = data[0].value;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.getPrevVouchNo = function () {
        $http.get('/Transaction/CashChequeReceive/getPrevVouchNo/').
          success(function (data) {
              $scope.cashCheqReceive.prev_voucher_no = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.getInvestorInfoForAdd = function () {
        $scope.customStyle = {};
        var client_id = $scope.cashCheqReceive.client_id;
        var branch_id = $scope.cashCheqReceive.broker_branch_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            //$http.get('/Transaction/CashChequeReceive/getInvestorInfoById/?id=' + client_id + 'branch=' + branch_id).
            $http.get('/Transaction/CashChequeReceive/getInvestorInfoById/', { params: { "id": client_id, "branch": branch_id } }).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align" : "left" };
                  $scope.cashCheqReceive.first_holder_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.cashCheqReceive.invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.cashCheqReceive.invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.cashCheqReceive.invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.cashCheqReceive.invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.cashCheqReceive.invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.cashCheqReceive.invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.cashCheqReceive.invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.cashCheqReceive.invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.cashCheqReceive.first_holder_name += " and " + data.investor.join_holder_name;
                  }

                  $scope.cashCheqReceive.available_balance = data.investor.available_balance;
                  $scope.cashCheqReceive.ledger_balance = data.investor.ledger_balance;
                  $scope.cashCheqReceive.active_status_id = data.investor.active_status_id;
                  $scope.cashCheqReceive.fldInv = true;
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.cashCheqReceive.first_holder_name = data.errorMessage;
                  $scope.cashCheqReceive.fldInv = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.cashCheqReceive.first_holder_name = "";
              $scope.cashCheqReceive.fldInv = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.getInvestorInfoForEdit = function () {
        $scope.customStyle = {};
        var client_id = $scope.editCashCheqReceive.client_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Transaction/CashChequeReceive/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.editCashCheqReceive.first_holder_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.editCashCheqReceive.invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editCashCheqReceive.invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.editCashCheqReceive.invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editCashCheqReceive.invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.editCashCheqReceive.invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editCashCheqReceive.invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.editCashCheqReceive.invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editCashCheqReceive.invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.editCashCheqReceive.first_holder_name += " and " + data.investor.join_holder_name;
                  }

                  $scope.editCashCheqReceive.available_balance = data.investor.available_balance;
                  $scope.editCashCheqReceive.ledger_balance = data.investor.ledger_balance;
                  $scope.editCashCheqReceive.active_status_id = data.investor.active_status_id;
                  $scope.editCashCheqReceive.fldInv = true;
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.editCashCheqReceive.first_holder_name = data.errorMessage;
                  $scope.editCashCheqReceive.fldInv = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.editCashCheqReceive.first_holder_name = "";
              $scope.editCashCheqReceive.fldInv = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.showHideBankInfoForAdd = function () {
        if (isundefinedornullservice.isUndefinedOrNull($scope.cashCheqReceive.transaction_mode_id)) {
            $scope.cashCheqReceive.cheque_dt = "";
            $scope.cashCheqReceive.cheque_no = "";
            $scope.cashCheqReceive.bank_id = "";
            $scope.cashCheqReceive.bank_branch_name = "";
            $scope.cashCheqReceive.fldBank = false;
        }
        else {
            var transactionModeName = dropdownservice.getSelectedText($scope.transactionModeList, $scope.cashCheqReceive.transaction_mode_id);
            if (transactionModeName != "CS") {
                $scope.cashCheqReceive.fldBank = true;
                $scope.cashCheqReceive.cheque_dt = globalvalueservice.getProcessDate();
            }
            else {
                $scope.cashCheqReceive.cheque_dt = "";
                $scope.cashCheqReceive.cheque_no = "";
                $scope.cashCheqReceive.bank_id = "";
                $scope.cashCheqReceive.bank_branch_name = "";
                $scope.cashCheqReceive.fldBank = false;
            }
        }
    };

    $scope.showHideBankInfoForEdit = function () {
        if (isundefinedornullservice.isUndefinedOrNull($scope.editCashCheqReceive.transaction_mode_id)) {
            $scope.editCashCheqReceive.cheque_dt = "";
            $scope.editCashCheqReceive.cheque_no = "";
            $scope.editCashCheqReceive.bank_id = "";
            $scope.editCashCheqReceive.bank_branch_name = "";
            $scope.editCashCheqReceive.fldBank = false;
        }
        else {
            var transactionModeName = dropdownservice.getSelectedText($scope.transactionModeList, $scope.editCashCheqReceive.transaction_mode_id);
            if (transactionModeName != "CS") {
                $scope.editCashCheqReceive.fldBank = true;
                if (isundefinedornullservice.isUndefinedOrNull($scope.editCashCheqReceive.cheque_dt) || $scope.editCashCheqReceive.cheque_dt == null || $scope.editCashCheqReceive.cheque_dt.toString().trim() == "") {
                    $scope.editCashCheqReceive.cheque_dt = globalvalueservice.getProcessDate();
                }
            }
            else {
                $scope.editCashCheqReceive.cheque_dt = "";
                $scope.editCashCheqReceive.cheque_no = "";
                $scope.editCashCheqReceive.bank_id = "";
                $scope.editCashCheqReceive.bank_branch_name = "";
                $scope.editCashCheqReceive.fldBank = false;
            }
        }
    };

    $scope.cashCheqReceive = {};
    $scope.saveNewCashCheqReceive = function () {
        if ($scope.cashCheqReceive.fldInv) {
            if ($scope.newCashCheqRecForm.$valid) {

                var transactionModeName = dropdownservice.getSelectedText($scope.transactionModeList, $scope.cashCheqReceive.transaction_mode_id);

                var chequeDate = $scope.cashCheqReceive.cheque_dt;

                if (transactionModeName != "CS" && transactionModeName != "ET") {
                    var chequeNo = $scope.cashCheqReceive.cheque_no;
                    var bank = $scope.cashCheqReceive.bank_id;
                    var bankBranch = $scope.cashCheqReceive.bank_branch_name;

                    if (isundefinedornullservice.isUndefinedOrNull(chequeDate) || chequeDate.toString().trim() == "") {
                        toastr.error("Please insert cheque date!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(chequeNo) || chequeNo.toString().trim() == "") {
                        toastr.error("Please insert cheque no!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(bank) || bank.toString().trim() == "") {
                        toastr.error("Please select a bank!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(bankBranch) || bankBranch.toString().trim() == "") {
                        toastr.error("Please insert bank branch!!!!!");
                    }
                    else {
                        
                        var datefilter = $filter('date');

                        var receiveDate = $scope.cashCheqReceive.receive_dt;

                        var valueDate = datefilter($scope.cashCheqReceive.value_dt, 'dd/MM/yyyy');

                        $scope.cashCheqReceive.receive_date = dateconfigservice.FullDateUKtoDateKey(receiveDate);

                        $scope.cashCheqReceive.value_date = dateconfigservice.FullDateUKtoDateKey(valueDate);

                        if (!isundefinedornullservice.isUndefinedOrNull(chequeDate) && chequeDate.toString().trim() != "") {
                            chequeDate = datefilter($scope.cashCheqReceive.cheque_dt, 'dd/MM/yyyy');
                            $scope.cashCheqReceive.cheque_date = dateconfigservice.FullDateUKtoDateKey(chequeDate);
                        }

                        $http.get('/Transaction/CashChequeReceive/getPrevUnapprovedFndRecByClientId/' + $scope.cashCheqReceive.client_id).
                          success(function (data) {
                              if (data.success) {
                                  var isProcess = confirm(data.msg);
                                  if (isProcess == true) {
                                      $http({
                                          method: 'POST',
                                          url: '/Transaction/CashChequeReceive/addCashCheqReceive',
                                          data: $scope.cashCheqReceive
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
                                      url: '/Transaction/CashChequeReceive/addCashCheqReceive',
                                      data: $scope.cashCheqReceive
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
                else {
                        
                    var datefilter = $filter('date');

                    var receiveDate = $scope.cashCheqReceive.receive_dt;

                    var valueDate = datefilter($scope.cashCheqReceive.value_dt, 'dd/MM/yyyy');

                    $scope.cashCheqReceive.receive_date = dateconfigservice.FullDateUKtoDateKey(receiveDate);

                    $scope.cashCheqReceive.value_date = dateconfigservice.FullDateUKtoDateKey(valueDate);

                    if (!isundefinedornullservice.isUndefinedOrNull(chequeDate) && chequeDate.toString().trim() != "") {
                        chequeDate = datefilter($scope.cashCheqReceive.cheque_dt, 'dd/MM/yyyy');
                        $scope.cashCheqReceive.cheque_date = dateconfigservice.FullDateUKtoDateKey(chequeDate);
                    }

                    $http.get('/Transaction/CashChequeReceive/getPrevUnapprovedFndRecByClientId/' + $scope.cashCheqReceive.client_id).
                      success(function (data) {
                          if (data.success) {
                              var isProcess = confirm(data.msg);
                              if (isProcess == true) {
                                  $http({
                                      method: 'POST',
                                      url: '/Transaction/CashChequeReceive/addCashCheqReceive',
                                      data: $scope.cashCheqReceive
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
                                  url: '/Transaction/CashChequeReceive/addCashCheqReceive',
                                  data: $scope.cashCheqReceive
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
    };

    $scope.loadCashCheqRecList = function () {
        $http.get('/Transaction/CashChequeReceive/getCashCheqRecList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.cashCheqRecList;
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

    $scope.DeleteFundReceive = function (row) {
        var isDelete = confirm("Are you sure you want to delete this object value!");
        if (isDelete == true) {
            $http({
                method: 'POST',
                url: '/Transaction/CashChequeReceive/deleteCashChequeReceive',
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

    $scope.loadCashCheqRecAndDdlById = function () {
        $scope.loadBank();
        $scope.loadBranch();
        $scope.loadTransactionModeForEdit();
    };

    $scope.loadCashCheqRecById = function (id) {
        $http.get('/Transaction/CashChequeReceive/getCashCheqRecById/' + id).
          success(function (data) {
              if (data.success) {
                  $scope.editCashCheqReceive = data.editCashCheqReceive;
                  $scope.getInvestorInfoForEdit();
                  $scope.showHideBankInfoForEdit();
                  $scope.amountInWord($scope.editCashCheqReceive.amount);
              }
              else {
                  toastr.error(data.errorMessage);
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.editCashChequeReceive = function () {
        if ($scope.editCashCheqReceive.fldInv) {
            if ($scope.editCashCheqRecForm.$valid) {

                var transactionModeName = dropdownservice.getSelectedText($scope.transactionModeList, $scope.editCashCheqReceive.transaction_mode_id);

                var chequeDate = $scope.editCashCheqReceive.cheque_dt;

                if (transactionModeName != "CS" && transactionModeName != "ET") {
                    var chequeNo = $scope.editCashCheqReceive.cheque_no;editCashCheqReceive
                    var bank = $scope.editCashCheqReceive.bank_id;
                    var bankBranch = $scope.editCashCheqReceive.bank_branch_name;

                    if (isundefinedornullservice.isUndefinedOrNull(chequeDate) || chequeDate.toString().trim() == "") {
                        toastr.error("Please insert cheque date!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(chequeNo) || chequeNo.toString().trim() == "") {
                        toastr.error("Please insert cheque no!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(bank) || bank.toString().trim() == "") {
                        toastr.error("Please select a bank!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(bankBranch) || bankBranch.toString().trim() == "") {
                        toastr.error("Please insert bank branch!!!!!");
                    }
                    else {
                        var datefilter = $filter('date');

                        var receiveDate = $scope.editCashCheqReceive.receive_dt;

                        var valueDate = datefilter($scope.editCashCheqReceive.value_dt, 'dd/MM/yyyy');

                        $scope.editCashCheqReceive.receive_date = dateconfigservice.FullDateUKtoDateKey(receiveDate);

                        $scope.editCashCheqReceive.value_date = dateconfigservice.FullDateUKtoDateKey(valueDate);

                        if (!isundefinedornullservice.isUndefinedOrNull(chequeDate) && chequeDate.toString().trim() != "") {
                            chequeDate = datefilter($scope.editCashCheqReceive.cheque_dt, 'dd/MM/yyyy');
                            $scope.editCashCheqReceive.cheque_date = dateconfigservice.FullDateUKtoDateKey(chequeDate);
                        }

                        $http({
                            method: 'POST',
                            url: '/Transaction/CashChequeReceive/updateCashCheqReceive',
                            data: $scope.editCashCheqReceive
                        }).success(function (data) {
                            if (data.success) {
                                toastr.success("Submitted Successfully");
                                $location.path('/FundReceiveList');
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
                        
                    var datefilter = $filter('date');

                    var receiveDate = $scope.editCashCheqReceive.receive_dt;

                    var valueDate = datefilter($scope.editCashCheqReceive.value_dt, 'dd/MM/yyyy');

                    $scope.editCashCheqReceive.receive_date = dateconfigservice.FullDateUKtoDateKey(receiveDate);

                    $scope.editCashCheqReceive.value_date = dateconfigservice.FullDateUKtoDateKey(valueDate);

                    if (!isundefinedornullservice.isUndefinedOrNull(chequeDate) && chequeDate.toString().trim() != "") {
                        chequeDate = datefilter($scope.editCashCheqReceive.cheque_dt, 'dd/MM/yyyy');
                        $scope.editCashCheqReceive.cheque_date = dateconfigservice.FullDateUKtoDateKey(chequeDate);
                    }

                    $http({
                        method: 'POST',
                        url: '/Transaction/CashChequeReceive/updateCashCheqReceive',
                        data: $scope.editCashCheqReceive
                    }).success(function (data) {
                        if (data.success) {
                            toastr.success("Submitted Successfully");
                            $location.path('/FundReceiveList');
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
        $scope.cashCheqReceive = {};

        $scope.amount_in_word = "";

        $scope.cashCheqReceive.value_dt = globalvalueservice.getProcessDate();

        $scope.cashCheqReceive.receive_dt = globalvalueservice.getProcessDate();

        $scope.cashCheqReceive.voucher_no = "Auto";
        $scope.loadBranch();
        $scope.getPrevVouchNo();
        $scope.showHideBankInfoForAdd();
    };
})