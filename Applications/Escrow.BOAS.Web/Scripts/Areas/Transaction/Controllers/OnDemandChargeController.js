angular.module('myApp').controller('OnDemandChargeController', function ($scope, $window, $http, $location, $routeParams, $filter, dateconfigservice, dropdownservice, globalvalueservice, Upload, isundefinedornullservice) {

    $('#pageTitle').text("--- On Demand Charges");

    $scope.image = '../Images/images.png';
    $scope.signature = '../Images/signature.jpg';

    $scope.showErrorModal = false;
    $scope.showUploadListModal = false;
    $scope.showProcessedListModal = false;

    $scope.isExcelValid = false;

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
        $scope.OnDemChar = {};
        $scope.OnDemChar.transaction_dt = globalvalueservice.getProcessDate();

        $scope.OnDemChar.value_dt = globalvalueservice.getProcessDate();

        $scope.OnDemChar.serial_no = "Auto";

        $scope.loadCharge();
        $scope.loadTransactionType();
    };

    $scope.loadCharge = function () {
        $scope.chargeList = null;
        $http.get('/Transaction/OnDemandCharge/getChargeDdlList/').
          success(function (data) {
              $scope.chargeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadTransactionType = function () {
        $scope.transactionTypeList = null;
        $http.get('/Transaction/OnDemandCharge/getTransactionTypeDdlList/').
          success(function (data) {
              $scope.transactionTypeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.getInvestorInfoForAdd = function () {
        $scope.customStyle = {};
        var client_id = $scope.OnDemChar.client_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Transaction/OnDemandCharge/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.OnDemChar.first_holder_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.OnDemChar.invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.OnDemChar.invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.OnDemChar.invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.OnDemChar.invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.OnDemChar.invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.OnDemChar.invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.OnDemChar.invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.OnDemChar.invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.OnDemChar.first_holder_name += " and " + data.investor.join_holder_name;
                  }

                  $scope.OnDemChar.available_balance = data.investor.available_balance;
                  $scope.OnDemChar.ledger_balance = data.investor.ledger_balance;
                  $scope.OnDemChar.active_status_id = data.investor.active_status_id;
                  $scope.OnDemChar.fldInv = true;
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.OnDemChar.first_holder_name = data.errorMessage;
                  $scope.OnDemChar.fldInv = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.OnDemChar.first_holder_name = "";
              $scope.OnDemChar.fldInv = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.enableDisableFields = function () {

        if (!isundefinedornullservice.isUndefinedOrNull($scope.OnDemChar.excel_all_single_investor) && $scope.OnDemChar.excel_all_single_investor == "From Excel") {
            $scope.OnDemChar.fldFile = true;
            $scope.OnDemChar.fldFileView = true;
            $scope.OnDemChar.fldSlInv = false;
            $scope.OnDemChar.fldCharTran = true;
            $scope.OnDemChar.fldAmount = false;
            $scope.OnDemChar.fldOther = false;
            $scope.OnDemChar.fldInv = false;
        }
        else if (!isundefinedornullservice.isUndefinedOrNull($scope.OnDemChar.excel_all_single_investor) && $scope.OnDemChar.excel_all_single_investor == "All Investor") {
            $scope.OnDemChar.fldFile = false;
            $scope.OnDemChar.fldFileView = false;
            $scope.OnDemChar.fldSlInv = false;
            $scope.OnDemChar.fldCharTran = true;
            $scope.OnDemChar.fldAmount = true;
            $scope.OnDemChar.fldOther = true;
            $scope.OnDemChar.fldInv = false;
        }
        else if (!isundefinedornullservice.isUndefinedOrNull($scope.OnDemChar.excel_all_single_investor) && $scope.OnDemChar.excel_all_single_investor == "Single Investor") {
            $scope.OnDemChar.fldFile = false;
            $scope.OnDemChar.fldFileView = false;
            $scope.OnDemChar.fldSlInv = true;
            $scope.OnDemChar.fldCharTran = true;
            $scope.OnDemChar.fldAmount = true;
            $scope.OnDemChar.fldOther = true;
            if ($("#first_holder_name").text() != "") {
                $scope.OnDemChar.fldInv = true;
            }
            else {
                $scope.OnDemChar.fldInv = false;
            }
        }
        else {
            toastr.error("Please Select 'From Excel' or 'All Investor' or 'Single Investor'");
        }
    };

    $scope.uploadList = function (exelFile) {
        if (isundefinedornullservice.isUndefinedOrNull(exelFile)) {
            toastr.error("Please select a file to upload!!!!!");
        }
        else {
            Upload.upload(
             {
                 url: '/Transaction/OnDemandCharge/uploadChargeFromExcel',
                 method: 'POST',
                 file: exelFile,
                 async: true

             })
         .success(function (data) {
             if (data.success) {
                 $scope.isExcelValid = true;
                 toastr.success('Uploaded Successfully');
             }
             else if (data.errorType == "list") {
                 $scope.isExcelValid = false;
                 $scope.errorRowCollection = [];
                 $scope.errorRowCollection = data.errorList;
                 $scope.errorDisplayedCollection = [].concat($scope.errorRowCollection);
                 $scope.showErrorModal = !$scope.showErrorModal;
             }
             else {
                 toastr.error(data.errorMsg);
             }
         })
         .error(function (XMLHttpRequest, textStatus, errorThrown) {
             toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
         });
        }
    };

    $scope.viewList = function () {
        $scope.uploadRowCollection = [];
        $http.get('/Transaction/OnDemandCharge/getExcelUploadList/').
          success(function (data) {
              if (data.success) {
                  $scope.uploadRowCollection = data.uploadList;
                  $scope.uploadDisplayedCollection = [].concat($scope.uploadRowCollection);
                  $scope.showUploadListModal = !$scope.showUploadListModal;
              }
              else {
                  toastr.error(data.errorMessage);
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.OnDemChar = {};
    $scope.saveNewOnDemandCharge = function () {
        if ($scope.newOnDemCharForm.$valid) {
            var datefilter = $filter('date');
            if (!isundefinedornullservice.isUndefinedOrNull($scope.OnDemChar.excel_all_single_investor) && $scope.OnDemChar.excel_all_single_investor == "From Excel") {
                if (!$scope.isExcelValid && !isundefinedornullservice.isUndefinedOrNull($scope.errorRowCollection)) {
                    $scope.showErrorModal = !$scope.showErrorModal;
                }
                else {
                    var transactionDate = globalvalueservice.getProcessDate();

                    var transaction_date = dateconfigservice.FullDateUKtoDateKey(transactionDate);

                    $scope.processedRowCollection = [];
                    $http.get('/Transaction/OnDemandCharge/getAlreadyProcessedList?charge_id=' + $scope.OnDemChar.charge_id + '&transaction_type_id=' + $scope.OnDemChar.transaction_type_id + '&transaction_date=' + transaction_date).
                      success(function (data) {
                          if (data.success) {
                              $scope.processedRowCollection = data.processedList;
                              $scope.processedDisplayedCollection = [].concat($scope.processedRowCollection);
                              $scope.showProcessedListModal = !$scope.showProcessedListModal;
                          }
                          else {
                              $scope.OnDemChar.transaction_date = transaction_date;
                              $scope.OnDemChar.value_date = transaction_date;
                              $http({
                                  method: 'POST',
                                  url: '/Transaction/OnDemandCharge/importExcelData',
                                  data: { OnDemChar: $scope.OnDemChar, isUpdProcessedData: false }
                              }).success(function (data) {
                                  if (data.success) {
                                      toastr.success("Import Successfully");
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
            else if (!isundefinedornullservice.isUndefinedOrNull($scope.OnDemChar.excel_all_single_investor) && $scope.OnDemChar.excel_all_single_investor == "All Investor") {
                var charge = $scope.OnDemChar.charge_id;
                var transactionType = $scope.OnDemChar.transaction_type_id;
                var amount = $scope.OnDemChar.amount;
                var transactionDate = $scope.OnDemChar.transaction_dt;
                var valueDate = $scope.OnDemChar.value_dt;

                if (isundefinedornullservice.isUndefinedOrNull(charge) || charge.toString().trim() == "") {
                    toastr.error("Please select charge!!!!!");
                }
                else if (isundefinedornullservice.isUndefinedOrNull(transactionType) || transactionType.toString().trim() == "") {
                    toastr.error("Please select trans. mode!!!!!");
                }
                else if (isundefinedornullservice.isUndefinedOrNull(amount) || amount.toString().trim() == "") {
                    toastr.error("Please insert amount!!!!!");
                }
                else if (isundefinedornullservice.isUndefinedOrNull(valueDate) || valueDate.toString().trim() == "") {
                    toastr.error("Please insert value date!!!!!");
                }
                else {

                    $scope.OnDemChar.transaction_date = dateconfigservice.FullDateUKtoDateKey(transactionDate);

                    valueDate = datefilter(valueDate, 'dd/MM/yyyy');
                    $scope.OnDemChar.value_date = dateconfigservice.FullDateUKtoDateKey(valueDate);

                    $http({
                        method: 'POST',
                        url: '/Transaction/OnDemandCharge/addAllOnDemandCharge',
                        data: $scope.OnDemChar
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
            else if (!isundefinedornullservice.isUndefinedOrNull($scope.OnDemChar.excel_all_single_investor) && $scope.OnDemChar.excel_all_single_investor == "Single Investor") {

                var invCode = $scope.OnDemChar.client_id;

                if (isundefinedornullservice.isUndefinedOrNull(invCode) || invCode.toString().trim() == "") {
                    toastr.error("Please insert investor code!!!!!");
                }
                else if ($scope.OnDemChar.fldInv) {
                    var charge = $scope.OnDemChar.charge_id;
                    var transactionType = $scope.OnDemChar.transaction_type_id;
                    var amount = $scope.OnDemChar.amount;
                    var transactionDate = $scope.OnDemChar.transaction_dt;
                    var valueDate = $scope.OnDemChar.value_dt;

                    if (isundefinedornullservice.isUndefinedOrNull(charge) || charge.toString().trim() == "") {
                        toastr.error("Please select charge!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(transactionType) || transactionType.toString().trim() == "") {
                        toastr.error("Please select trans. mode!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(amount) || amount.toString().trim() == "") {
                        toastr.error("Please insert amount!!!!!");
                    }
                    else if (isundefinedornullservice.isUndefinedOrNull(valueDate) || valueDate.toString().trim() == "") {
                        toastr.error("Please insert value date!!!!!");
                    }
                    else {

                        $scope.OnDemChar.transaction_date = dateconfigservice.FullDateUKtoDateKey(transactionDate);

                        valueDate = datefilter(valueDate, 'dd/MM/yyyy');
                        $scope.OnDemChar.value_date = dateconfigservice.FullDateUKtoDateKey(valueDate);

                        $http({
                            method: 'POST',
                            url: '/Transaction/OnDemandCharge/addSingleInvOnDemandCharge',
                            data: $scope.OnDemChar
                        }).success(function (data) {
                            if (data.success) {
                                toastr.success("Submitted Successfully");
                                $scope.OnDemChar.serial_no = data.serial_no;
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
                toastr.error("Please Select 'From Excel' or 'All Investor' or 'Single Investor'");
            }
        }
    };

    $scope.saveExcelData = function (isUpdProcessedData) {
        var processDate = globalvalueservice.getProcessDate();

        var process_date = dateconfigservice.FullDateUKtoDateKey(processDate);

        $scope.OnDemChar.transaction_date = process_date;
        $scope.OnDemChar.value_date = process_date;

        if (isUpdProcessedData) {

            $http({
                method: 'POST',
                url: '/Transaction/OnDemandCharge/importExcelData',
                data: { OnDemChar: $scope.OnDemChar, isUpdProcessedData: isUpdProcessedData }
            }).success(function (data) {
                if (data.success) {
                    $scope.showProcessedListModal = !$scope.showProcessedListModal;
                    toastr.success("Import Successfully");
                }
                else {
                    $scope.showProcessedListModal = !$scope.showProcessedListModal;
                    toastr.error(data.errorMessage);
                }
            }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
        else {

            $http({
                method: 'POST',
                url: '/Transaction/OnDemandCharge/importExcelData',
                data: { OnDemChar: $scope.OnDemChar, isUpdProcessedData: isUpdProcessedData }
            }).success(function (data) {
                if (data.success) {
                    $scope.showProcessedListModal = !$scope.showProcessedListModal;
                    toastr.success("Import Successfully");
                }
                else {
                    $scope.showProcessedListModal = !$scope.showProcessedListModal;
                    toastr.error(data.errorMessage);
                }
            }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.closeProcessedListModal = function () {
        $scope.showProcessedListModal = !$scope.showProcessedListModal;
    };

    $scope.loadOnDemandChargeList = function () {
        $scope.rowCollection = [];
        $http.get('/Transaction/OnDemandCharge/getOnDemandChargeList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.onDemandChargeList;
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

    $scope.refresh = function () {
        $scope.OnDemChar = {};

        $scope.amount_in_word = "";

        $scope.OnDemChar.transaction_dt = globalvalueservice.getProcessDate();

        $scope.OnDemChar.value_dt = globalvalueservice.getProcessDate();

        $scope.OnDemChar.serial_no = "Auto";

        $scope.loadCharge();
        $scope.loadTransactionType();
    };
})