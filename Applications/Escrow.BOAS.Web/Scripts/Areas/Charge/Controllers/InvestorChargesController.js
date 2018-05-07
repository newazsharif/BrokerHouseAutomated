angular.module('myApp').controller('InvestorChargesController', function ($scope, $window, $http, $routeParams, $location, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("--- Investor Charges");

    $scope.image = '../Images/images.png';
    $scope.signature = '../Images/signature.jpg';


    $scope.loadDropdowns = function () {

        $scope.loadCharge();
    };


    $scope.loadDropdownsAndInfo = function () {

        $scope.loadCharge();

        $scope.loadInvChargeById($routeParams.id);
    };

    $scope.loadInvChargeById = function (id) {
        $scope.rowCollection = [];
        $http.get('/Charge/InvestorCharges/getInvChargeById/' + id).
          success(function (data) {
              if (data.success) {
                  $scope.editInvCharges = data.invCharges;
                  if (data.invCharges.is_slab == 1) {
                      $scope.rowCollection = data.invChargeSlab;
                      $scope.displayedCollection = [].concat($scope.rowCollection);

                      $scope.fldSlab = true;
                  }

                  $scope.getInvestorInfoForEdit();
              }
              else {
                  toastr.error(data.errorMessage);
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadCharge = function () {
        $scope.chargeList = null;
        $http.get('/Charge/InvestorCharges/getChargeDdlList/').
          success(function (data) {
              $scope.chargeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.showHideSlab = function () {

        $scope.rowCollection = [];

        var slabList = {};

        if (isundefinedornullservice.isUndefinedOrNull($scope.invCharges.is_slab) || $scope.invCharges.is_slab.toString().trim() == "") {
            slabList = {};

            $scope.rowCollection = [];
            $scope.displayedCollection = [].concat($scope.rowCollection);
        }
        else if ($scope.invCharges.is_slab == "0") {
            slabList = {};

            $scope.rowCollection = [];
            $scope.displayedCollection = [].concat($scope.rowCollection);
        }
        else {
            slabList = {
                amount_from: 0,
                amount_to: 0,
                charge_amount: 0
            };

            $scope.rowCollection.push(slabList);
            $scope.displayedCollection = [].concat($scope.rowCollection);
        }
    };

    $scope.showHideSlabForEdit = function () {

        $scope.rowCollection = [];

        var slabList = {};

        if (isundefinedornullservice.isUndefinedOrNull($scope.editInvCharges.is_slab) || $scope.editInvCharges.is_slab.toString().trim() == "") {
            slabList = {};

            $scope.rowCollection = [];
            $scope.displayedCollection = [].concat($scope.rowCollection);

            $scope.fldSlab = false;
        }
        else if ($scope.editInvCharges.is_slab == "0") {
            slabList = {};

            $scope.rowCollection = [];
            $scope.displayedCollection = [].concat($scope.rowCollection);

            $scope.fldSlab = false;
        }
        else {
            slabList = {
                id: 0,
                amount_from: 0,
                amount_to: 0,
                charge_amount: 0
            };

            $scope.rowCollection.push(slabList);
            $scope.displayedCollection = [].concat($scope.rowCollection);

            $scope.fldSlab = true;
        }
    };

    $scope.AddInvSlab = function () {

        var max_amount_to = 0;
        var isAmountToZero = false;
        var isAmountToSmaller = false;
        var isChargeAmountInvalid = false;

        for (var i = 0; i < $scope.rowCollection.length; i++) {
            if (parseFloat($scope.rowCollection[i].charge_amount) == 0 || parseFloat($scope.rowCollection[i].charge_amount) < 0) {
                isChargeAmountInvalid = true;
                break;
            }
            else if (parseFloat($scope.rowCollection[i].amount_to) == 0) {
                isAmountToZero = true;
                break;
            }
            else if (parseFloat($scope.rowCollection[i].amount_to) < parseFloat($scope.rowCollection[i].amount_from)) {
                isAmountToSmaller = true;
                break;
            }
        }


        if (isChargeAmountInvalid) {
            toastr.error("Previous slab charge amount is invalid. please solve this issue first then try new slab....");
        }
        else if (isAmountToZero) {
            toastr.error("Previous amount to can not be 0. please solve this issue first then try new slab....");
        }
        else if (isAmountToSmaller) {
            toastr.error("Previous amount to is smaller than previous amount from which is invalid. please solve this issue first then try new slab....");
        }
        else {

            for (var i = 0; i < $scope.rowCollection.length; i++) {
                if (max_amount_to < parseFloat($scope.rowCollection[i].amount_to)) {
                    max_amount_to = parseFloat($scope.rowCollection[i].amount_to);
                }
            }

            max_amount_to++;

            var slabList = {
                amount_from: max_amount_to,
                amount_to: 0,
                charge_amount: 0
            };

            $scope.rowCollection.push(slabList);
            $scope.displayedCollection = [].concat($scope.rowCollection);
        }
    };

    $scope.AddInvSlabForEdit = function () {

        var max_amount_to = 0;
        var isAmountToZero = false;
        var isAmountToSmaller = false;
        var isChargeAmountInvalid = false;

        for (var i = 0; i < $scope.rowCollection.length; i++) {
            if (parseFloat($scope.rowCollection[i].charge_amount) == 0 || parseFloat($scope.rowCollection[i].charge_amount) < 0) {
                isChargeAmountInvalid = true;
                break;
            }
            else if (parseFloat($scope.rowCollection[i].amount_to) == 0) {
                isAmountToZero = true;
                break;
            }
            else if (parseFloat($scope.rowCollection[i].amount_to) < parseFloat($scope.rowCollection[i].amount_from)) {
                isAmountToSmaller = true;
                break;
            }
        }


        if (isChargeAmountInvalid) {
            toastr.error("Previous slab charge amount is invalid. please solve this issue first then try new slab....");
        }
        else if (isAmountToZero) {
            toastr.error("Previous amount to can not be 0. please solve this issue first then try new slab....");
        }
        else if (isAmountToSmaller) {
            toastr.error("Previous amount to is smaller than previous amount from which is invalid. please solve this issue first then try new slab....");
        }
        else {

            for (var i = 0; i < $scope.rowCollection.length; i++) {
                if (max_amount_to < parseFloat($scope.rowCollection[i].amount_to)) {
                    max_amount_to = parseFloat($scope.rowCollection[i].amount_to);
                }
            }

            max_amount_to++;

            var slabList = {
                id: 0,
                amount_from: max_amount_to,
                amount_to: 0,
                charge_amount: 0
            };

            $scope.rowCollection.push(slabList);
            $scope.displayedCollection = [].concat($scope.rowCollection);
        }
    };

    $scope.getInvestorInfoForAdd = function () {
        $scope.customStyle = {};
        var client_id = $scope.invCharges.client_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Charge/InvestorCharges/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.invCharges.first_holder_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.invCharges.invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.invCharges.invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.invCharges.invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.invCharges.invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.invCharges.invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.invCharges.invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.invCharges.invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.invCharges.invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.invCharges.first_holder_name += " and " + data.investor.join_holder_name;
                  }

                  $scope.invCharges.available_balance = data.investor.available_balance;
                  $scope.invCharges.ledger_balance = data.investor.ledger_balance;
                  $scope.invCharges.active_status_id = data.investor.active_status_id;
                  $scope.invCharges.fldInv = true;
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.invCharges.first_holder_name = data.errorMessage;
                  $scope.invCharges.fldInv = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.invCharges.first_holder_name = "";
              $scope.invCharges.fldInv = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.getInvestorInfoForEdit = function () {
        $scope.customStyle = {};
        var client_id = $scope.editInvCharges.client_id;
        if (!isundefinedornullservice.isUndefinedOrNull(client_id) && client_id.toString().trim() != "") {
            $http.get('/Charge/InvestorCharges/getInvestorInfoById/' + client_id).
          success(function (data) {
              if (data.success) {
                  $scope.customStyle.style = { "color": "green", "text-align": "left" };
                  $scope.editInvCharges.first_holder_name = data.investor.first_holder_name;

                  if (data.invPic != '') {
                      var imgByteCharacters = atob(data.invPic);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.editInvCharges.invPic = new Blob([imgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editInvCharges.invPic = "";
                  }

                  if (data.invSignature != '') {
                      var sigByteCharacters = atob(data.invSignature);
                      var sigByteNumbers = new Array(sigByteCharacters.length);
                      for (var i = 0; i < sigByteCharacters.length; i++) {
                          sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                      }
                      var sigByteArray = new Uint8Array(sigByteNumbers);
                      $scope.editInvCharges.invSignature = new Blob([sigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editInvCharges.invSignature = "";
                  }

                  if (data.invJoinHolderPic != '') {
                      var joinHolderImgByteCharacters = atob(data.invJoinHolderPic);
                      var joinHolderImgByteNumbers = new Array(joinHolderImgByteCharacters.length);
                      for (var i = 0; i < joinHolderImgByteCharacters.length; i++) {
                          joinHolderImgByteNumbers[i] = joinHolderImgByteCharacters.charCodeAt(i);
                      }
                      var joinHolderImgByteArray = new Uint8Array(joinHolderImgByteNumbers);
                      $scope.editInvCharges.invJoinHolderPic = new Blob([joinHolderImgByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editInvCharges.invJoinHolderPic = "";
                  }

                  if (data.invJoinHolderSignature != '') {
                      var joinHolderSigByteCharacters = atob(data.invJoinHolderSignature);
                      var joinHolderSigByteNumbers = new Array(joinHolderSigByteCharacters.length);
                      for (var i = 0; i < joinHolderSigByteCharacters.length; i++) {
                          joinHolderSigByteNumbers[i] = joinHolderSigByteCharacters.charCodeAt(i);
                      }
                      var joinHolderSigByteArray = new Uint8Array(joinHolderSigByteNumbers);
                      $scope.editInvCharges.invJoinHolderSignature = new Blob([joinHolderSigByteArray], { type: 'image' });
                  }
                  else {
                      $scope.editInvCharges.invJoinHolderSignature = "";
                  }

                  if (!isundefinedornullservice.isUndefinedOrNull(data.investor.join_holder_name) && data.investor.join_holder_name.toString().trim() != "") {
                      $scope.editInvCharges.first_holder_name += " and " + data.investor.join_holder_name;
                  }

                  $scope.editInvCharges.available_balance = data.investor.available_balance;
                  $scope.editInvCharges.ledger_balance = data.investor.ledger_balance;
                  $scope.editInvCharges.active_status_id = data.investor.active_status_id;
                  $scope.editInvCharges.fldInv = true;
              }
              else {
                  $scope.customStyle.style = { "color": "red", "text-align": "left" };
                  $scope.editInvCharges.first_holder_name = data.errorMessage;
                  $scope.editInvCharges.fldInv = false;
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              $scope.editInvCharges.first_holder_name = "";
              $scope.editInvCharges.fldInv = false;
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
        }
    };

    $scope.loadInvChargeList = function () {
        $scope.rowCollection = [];
        $http.get('/Charge/InvestorCharges/getInvChargesList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.invCharges;
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

    $scope.invCharges = {};
    $scope.addCharge = function () {
        if ($scope.invCharges.fldInv) {
            if ($scope.newInvChargeForm.$valid) {
                if (isundefinedornullservice.isUndefinedOrNull($scope.invCharges.is_percentage) || $scope.invCharges.is_percentage.toString().trim() == "") {
                    $scope.invCharges.is_percentage = 0;
                }

                if (isundefinedornullservice.isUndefinedOrNull($scope.invCharges.is_slab) || $scope.invCharges.is_slab.toString().trim() == "") {
                    $scope.invCharges.is_slab = 0;
                }
                else if ($scope.invCharges.is_slab == "1") {

                    var isAmountToZero = false;
                    var isAmountToSmaller = false;
                    var isChargeAmountInvalid = false;

                    for (var i = 0; i < $scope.rowCollection.length; i++) {
                        if (parseFloat($scope.rowCollection[i].charge_amount) == 0 || parseFloat($scope.rowCollection[i].charge_amount) < 0) {
                            isChargeAmountInvalid = true;
                            break;
                        }
                        else if (parseFloat($scope.rowCollection[i].amount_to) == 0) {
                            isAmountToZero = true;
                            break;
                        }
                        else if (parseFloat($scope.rowCollection[i].amount_to) < parseFloat($scope.rowCollection[i].amount_from)) {
                            isAmountToSmaller = true;
                            break;
                        }
                    }


                    if (isChargeAmountInvalid) {
                        toastr.error("One of slab charge amount is invalid. please solve this issue first then try new slab....");
                    }
                    else if (isAmountToZero) {
                        toastr.error("One of slab amount to is 0. please solve this issue first then try new slab....");
                    }
                    else if (isAmountToSmaller) {
                        toastr.error("One of slab amount to is smaller than  amount from which is invalid. please solve this issue first then try new slab....");
                    }
                    else {
                        $http({
                            method: 'POST',
                            url: '/Charge/InvestorCharges/AddInvestorCharges',
                            data: { invCharges: $scope.invCharges, invChargeSlabs: $scope.rowCollection }
                        }).
                        success(function (data) {
                            if (data.success) {
                                $scope.refresh();
                                toastr.success("Save Successfully");
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
                        url: '/Charge/InvestorCharges/AddInvestorCharges',
                        data: { invCharges: $scope.invCharges, invChargeSlabs: $scope.rowCollection }
                    }).
                    success(function (data) {
                        if (data.success) {
                            $scope.refresh();
                            toastr.success("Save Successfully");
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

    $scope.editInvCharges = {};
    $scope.editCharge = function () {
        if ($scope.editInvCharges.fldInv) {
            if ($scope.editInvChargeForm.$valid) {
                if (isundefinedornullservice.isUndefinedOrNull($scope.editInvCharges.is_percentage) || $scope.editInvCharges.is_percentage.toString().trim() == "") {
                    $scope.editInvCharges.is_percentage = 0;
                }

                if (isundefinedornullservice.isUndefinedOrNull($scope.editInvCharges.is_slab) || $scope.editInvCharges.is_slab.toString().trim() == "") {
                    $scope.editInvCharges.is_slab = 0;
                }
                else if ($scope.editInvCharges.is_slab == "1") {

                    var isAmountToZero = false;
                    var isAmountToSmaller = false;
                    var isChargeAmountInvalid = false;

                    for (var i = 0; i < $scope.rowCollection.length; i++) {
                        if (parseFloat($scope.rowCollection[i].charge_amount) == 0 || parseFloat($scope.rowCollection[i].charge_amount) < 0) {
                            isChargeAmountInvalid = true;
                            break;
                        }
                        else if (parseFloat($scope.rowCollection[i].amount_to) == 0) {
                            isAmountToZero = true;
                            break;
                        }
                        else if (parseFloat($scope.rowCollection[i].amount_to) < parseFloat($scope.rowCollection[i].amount_from)) {
                            isAmountToSmaller = true;
                            break;
                        }
                    }


                    if (isChargeAmountInvalid) {
                        toastr.error("One of slab charge amount is invalid. please solve this issue first then try new slab....");
                    }
                    else if (isAmountToZero) {
                        toastr.error("One of slab amount to is 0. please solve this issue first then try new slab....");
                    }
                    else if (isAmountToSmaller) {
                        toastr.error("One of slab amount to is smaller than  amount from which is invalid. please solve this issue first then try new slab....");
                    }
                    else {
                        $http({
                            method: 'POST',
                            url: '/Charge/InvestorCharges/UpdateInvestorCharges',
                            data: { invCharges: $scope.editInvCharges, invChargeSlabs: $scope.rowCollection }
                        }).
                        success(function (data) {
                            if (data.success) {
                                $location.path('/InvestorChargesList');
                                toastr.success("Save Successfully");
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
                        url: '/Charge/InvestorCharges/UpdateInvestorCharges',
                        data: { invCharges: $scope.editInvCharges, invChargeSlabs: $scope.rowCollection }
                    }).
                    success(function (data) {
                        if (data.success) {
                            $location.path('/InvestorChargesList');
                            toastr.success("Save Successfully");
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

    $scope.DeleteInvSlab = function (row) {
        var index = $scope.rowCollection.indexOf(row);
        if (index !== -1) {
            $scope.rowCollection.splice(index, 1);
        }
    }

    $scope.DeleteInvCharge = function (row) {
        var isDelete = confirm("Are you sure you want to delete this charge!");
        if (isDelete == true) {

            $http({
                method: 'POST',
                url: '/Charge/InvestorCharges/deleteInvCharges',
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
    };

    $scope.refresh = function () {
        $scope.invCharges = {};

        $scope.invCharges.fldInv = false;

        $scope.rowCollection = [];
        $scope.displayedCollection = [].concat($scope.rowCollection);
        $scope.invCharges = {};

        $scope.editInvCharges.fldInv = false;

       $scope.editInvCharges = {};

        $scope.fldSlab = false;

        $scope.loadCharge();
    };
})