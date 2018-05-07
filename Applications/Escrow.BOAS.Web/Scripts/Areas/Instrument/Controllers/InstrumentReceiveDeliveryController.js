angular.module('myApp').controller('InstrumentReceiveDeliveryController', function ($scope, $window, $http, $location, $routeParams, $filter, dateconfigservice, dropdownservice, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("---Instrument Receive Delivery");

    $scope.image = '../Images/images.png';
    $scope.signature = '../Images/signature.jpg';

    $scope.loadDropdowns = function () {
        $scope.insRecDel = {};
        $scope.insRecDel.process_date = globalvalueservice.getProcessDate();
        $scope.loadTransactionType();
        $scope.loadInstrument();
    };


    $scope.loadInstrument = function () {
        $scope.instrumentList = null;
        $scope.insRecDel.market_unit_price = 'Market Price';
        $http.get('/Instrument/InstrumentReceiveDelivery/getInstrumentDdlList').
        success(function (data) {
            $scope.instrumentList = data;
        }).
        error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });

    };

    $scope.loadTransactionType = function () {
        $scope.transactionTypeList = null;
        $http.get('/Instrument/InstrumentReceiveDelivery/getTransactionTypeDdlList').
          success(function (data) {
              $scope.transactionTypeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };


    $scope.getInvestorInfoForAdd = function () {
        $scope.customStyle = {};
        var client_id = $scope.insRecDel.client_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Instrument/InstrumentReceiveDelivery/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.insRecDel.first_holder_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.insRecDel.invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.insRecDel.invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.insRecDel.invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.insRecDel.invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.insRecDel.invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.insRecDel.invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.insRecDel.invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.insRecDel.invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.insRecDel.first_holder_name += " and " + data.investor.join_holder_name;
                  }

                  $scope.insRecDel.available_balance = data.investor.available_balance;
                  $scope.insRecDel.ledger_balance = data.investor.ledger_balance;
                  $scope.insRecDel.active_status_id = data.investor.active_status_id;
                  $scope.insRecDel.fldInv = true;
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.insRecDel.first_holder_name = data.errorMessage;
                  $scope.insRecDel.fldInv = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.insRecDel.first_holder_name = "";
              $scope.insRecDel.fldInv = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };


    $scope.saveNewInstrumentReceiveDelivery = function () {
        var client_id = $scope.insRecDel.client_id;
        var transection_type = $scope.insRecDel.transaction_type_id;
        var transection_date = $scope.insRecDel.process_date;
        $scope.insRecDel.transaction_date = dateconfigservice.FullDateUKtoDateKey(transection_date);
        var ref_no = $scope.insRecDel.reference_no;
        var instrument = $scope.insRecDel.instrument_id;
        var quantity = $scope.insRecDel.quantity;
        var active_status_id = $scope.insRecDel.active_status_id;
        if ($scope.newInstrumentReceiveDeliveryForm.$valid)
        {
            if (isundefinedornullservice.isUndefinedOrNull($scope.insRecDel.market_unit_price)) {
                toastr.error("Please select Unit Price or Market Price!!!");
            }
            else if ($scope.insRecDel.market_unit_price == "Unit Price" && (isundefinedornullservice.isUndefinedOrNull($scope.insRecDel.unit_price) || $scope.insRecDel.unit_price.toString().trim() == "")) {
                toastr.error("Please insert a Unit Price!!!");
            }
            else if ($scope.insRecDel.market_unit_price == "Unit Price") {
                $scope.insRecDel.rate = $scope.insRecDel.unit_price;
                $http({
                    method: 'POST',
                    url: '/Instrument/InstrumentReceiveDelivery/SaveNewInstrumentReceiveDelivery',
                    data: $scope.insRecDel
                }).success(function (data) {
                    if (data.success) {
                        toastr.success("Submitted Successfully");
                        $location.path('/InstrumentReceiveDeliveryList');
                    }
                    else {
                        toastr.error(data.errorMessage);
                    }
                });
            }
            else if ($scope.insRecDel.market_unit_price == "Market Price") {
                $scope.insRecDel.rate = $scope.face_value;
                $http({
                    method: 'POST',
                    url: '/Instrument/InstrumentReceiveDelivery/SaveNewInstrumentReceiveDelivery',
                    data: $scope.insRecDel
                }).success(function (data) {
                    if (data.success) {
                        toastr.success("Submitted Successfully");
                        $location.path('/InstrumentReceiveDeliveryList');
                    }
                    else {
                        toastr.error(data.errorMessage);
                    }
                });
            }
        }
        else {
            toastr.error("Insert all data");
        }
        
    };

    $scope.updateInstrumentReceiveDelivery = function()
    {
        var active_status_id = $scope.insRecDel.active_status_id;
        var transection_date = $scope.insRecDel.process_date;
        var instrument = $scope.insRecDel.instrument_id;
        $scope.insRecDel.transaction_date = dateconfigservice.FullDateUKtoDateKey(transection_date);
        if ($scope.EditInstrumentReceiveDeliveryForm.$valid) {
            if (isundefinedornullservice.isUndefinedOrNull($scope.insRecDel.market_unit_price)) {
                toastr.error("Please select Unit Price or Market Price!!!");
            }
            else if ($scope.insRecDel.market_unit_price == "Unit Price" && (isundefinedornullservice.isUndefinedOrNull($scope.insRecDel.unit_price) || $scope.insRecDel.unit_price.toString().trim() == "")) {
                toastr.error("Please insert a Unit Price!!!");
            }
            else if ($scope.insRecDel.market_unit_price == "Unit Price") {
                $scope.insRecDel.rate = $scope.insRecDel.unit_price;
                $http({
                    method: 'POST',
                    url: '/Instrument/InstrumentReceiveDelivery/UpdateInstrumentReceiveDelivery',
                    data: $scope.insRecDel
                }).success(function (data) {
                    if (data.success) {
                        toastr.success("Updated Successfully");
                        $location.path('/InstrumentReceiveDeliveryList');
                    }
                    else {
                        toastr.error(data.errorMessage);
                    }
                });
            }
            else if ($scope.insRecDel.market_unit_price == "Market Price") {
                $scope.insRecDel.rate = $scope.face_value;
                $http({
                    method: 'POST',
                    url: '/Instrument/InstrumentReceiveDelivery/UpdateInstrumentReceiveDelivery',
                    data: $scope.insRecDel
                }).success(function (data) {
                    if (data.success) {
                        toastr.success("Updated Successfully");
                        $location.path('/InstrumentReceiveDeliveryList');
                    }
                    else {
                        toastr.error(data.errorMessage);
                    }
                });
            }
        }
        else {
            toastr.error("Insert all data");
        }
    }

    $scope.DeleteInstrumentReceiveDelivery = function(row)
    {
        var isDelete = confirm("Are you sure you want to delete this object!");
        if(isDelete == true)
        {
            $http.get('/Instrument/InstrumentReceiveDelivery/GetInstrumentReceiveDeliveryById/' + row.id).
                success(function (data) {
                    if (data.success) {
                        $http({
                            method: 'POST',
                            url: '/Instrument/InstrumentReceiveDelivery/DeleteInstrumentReceiveDelivery',
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
                        });

                    }
                });
        }
    }

    $scope.loadInstrumentReceiveDeliveryById = function()
    {
        $http.get('/Instrument/InstrumentReceiveDelivery/GetInstrumentReceiveDeliveryById/' + $routeParams.id)
       .success(function (data) {
           if (data.success) {
               $scope.insRecDel = data.EditinsRecDel;
               $scope.insRecDel.market_unit_price = 'Unit Price';
               $scope.getInvestorInfoForAdd();
               $scope.insRecDel.process_date = globalvalueservice.getProcessDate();
               $scope.insRecDel.unit_price = data.EditinsRecDel.rate;
               $scope.getFaceValue();
           }
           else {
               toastr.error(data.errorMessage);
           }
       }).
       error(function (XMLHttpRequest, textStatus, errorThrown) {
           toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
       });
    }

    $scope.getFaceValue = function () {
        var instrument_id = $scope.insRecDel.isin;
        if (!isundefinedornullservice.isUndefinedOrNull(instrument_id) && instrument_id.toString().trim() != "") {
            $http.get('/Instrument/InstrumentReceiveDelivery/getFaceValueById/' + instrument_id).
          success(function (data) {
              $scope.face_value = data.faceValueAndId.face_value;
              $scope.insRecDel.instrument_id = data.faceValueAndId.id;
          }).
             error(function (XMLHttpRequest, textStatus, errorThrown) {
                 toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
             });
        }
        else {

        }
    };

    $scope.loadInstrumentReceiveDeliveryList = function () {
        $scope.rowCollection = [];
        $http.get('/Instrument/InstrumentReceiveDelivery/GetAllInstrumentReceiveDelivery/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.insRecDel;
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
        $scope.insRecDel = {};

        $scope.insRecDel.transaction_type_id = 0;
        $scope.insRecDel.client_id = "";
        $scope.insRecDel.reference_no = "";
        $scope.insRecDel.isin = 0;
        $scope.insRecDel.market_unit_price = 'Market Price';
        $scope.insRecDel.process_date = globalvalueservice.getProcessDate();
        //$scope.cashCheqReceive.receive_dt = globalvalueservice.getProcessDate();

        //$scope.cashCheqReceive.voucher_no = "Auto";
        //$scope.getPrevVouchNo();

    };
});