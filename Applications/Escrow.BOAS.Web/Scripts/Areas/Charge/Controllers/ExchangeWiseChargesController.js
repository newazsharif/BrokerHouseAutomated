angular.module('myApp').controller('ExchangeWiseChargesController', function ($scope, $window, $http, $routeParams, $location, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("--- Exchange Wise Charges");


    $scope.loadDropdowns = function () {

        $scope.loadCharge();
        $scope.loadSecurityMarket();
    };


    $scope.loadDropdownsAndInfo = function () {

        $scope.loadCharge();
        $scope.loadSecurityMarket();

        $scope.loadExchangeWiseChargeById($routeParams.id);
    };

    $scope.loadExchangeWiseChargeById = function (id) {
        $scope.rowCollection = [];
        $http.get('Charge/ExchangeWiseCharges/getExchangeWiseChargeById/' + id).
          success(function (data) {
              if (data.success) {
                  $scope.editExchangeWiseCharges = data.exchangeWiseCharge;
                  if (data.exchangeWiseCharge.is_slab == 1) {
                      $scope.rowCollection = data.exchangeWiseChargeSlab;
                      $scope.displayedCollection = [].concat($scope.rowCollection);

                      $scope.fldSlab = true;
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

    $scope.loadCharge = function () {
        $scope.chargeList = null;
        $http.get('Charge/ExchangeWiseCharges/getChargeDdlList/').
          success(function (data) {
              $scope.chargeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadSecurityMarket = function () {
        $scope.stockExchangeList = null;
        $http.get('/Charge/ExchangeWiseCharges/getStockExchangeDdlList/').
          success(function (data) {
              $scope.stockExchangeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.showHideSlab = function () {

        $scope.rowCollection = [];

        var slabList = {};

        if (isundefinedornullservice.isUndefinedOrNull($scope.exchangeWiseCharge.is_slab) || $scope.exchangeWiseCharge.is_slab.toString().trim() == "") {
            slabList = {};

            $scope.rowCollection = [];
            $scope.displayedCollection = [].concat($scope.rowCollection);
        }
        else if ($scope.exchangeWiseCharge.is_slab == "0") {
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

        if (isundefinedornullservice.isUndefinedOrNull($scope.editExchangeWiseCharges.is_slab) || $scope.editExchangeWiseCharges.is_slab.toString().trim() == "") {
            slabList = {};

            $scope.rowCollection = [];
            $scope.displayedCollection = [].concat($scope.rowCollection);

            $scope.fldSlab = false;
        }
        else if ($scope.editExchangeWiseCharges.is_slab == "0") {
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

    $scope.AddExchangeSlab = function () {

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

    $scope.AddExchangeSlabForEdit = function () {

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

    $scope.loadExchangeWiseChargeList = function () {
        $scope.rowCollection = [];
        $http.get('Charge/ExchangeWiseCharges/getExchangeWiseChargesList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.exchangeWiseCharge;
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

    $scope.exchangeWiseCharge = {};
    $scope.addCharge = function () {
        if ($scope.newExchangeWiseChargeForm.$valid) {
            if (isundefinedornullservice.isUndefinedOrNull($scope.exchangeWiseCharge.is_percentage) || $scope.exchangeWiseCharge.is_percentage.toString().trim() == "") {
                $scope.exchangeWiseCharge.is_percentage = 0;
            }

            if (isundefinedornullservice.isUndefinedOrNull($scope.exchangeWiseCharge.is_slab) || $scope.exchangeWiseCharge.is_slab.toString().trim() == "") {
                $scope.exchangeWiseCharge.is_slab = 0;
            }
            else if ($scope.exchangeWiseCharge.is_slab == "1") {

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
                        url: 'Charge/ExchangeWiseCharges/AddExchangeWiseCharges',
                        data: { exchangeWiseCharge: $scope.exchangeWiseCharge, exchangeWiseChargeSlab: $scope.rowCollection }
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
                    url: 'Charge/ExchangeWiseCharges/AddExchangeWiseCharges',
                    data: { exchangeWiseCharge: $scope.exchangeWiseCharge, exchangeWiseChargeSlab: $scope.rowCollection }
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
    };

    $scope.editExchangeWiseCharges = {};
    $scope.editCharge = function () {
        if ($scope.editExchangeWiseChargeForm.$valid) {
            if (isundefinedornullservice.isUndefinedOrNull($scope.editExchangeWiseCharges.is_percentage) || $scope.editExchangeWiseCharges.is_percentage.toString().trim() == "") {
                $scope.editExchangeWiseCharges.is_percentage = 0;
            }

            if (isundefinedornullservice.isUndefinedOrNull($scope.editExchangeWiseCharges.is_slab) || $scope.editExchangeWiseCharges.is_slab.toString().trim() == "") {
                $scope.editExchangeWiseCharges.is_slab = 0;
            }
            else if ($scope.editExchangeWiseCharges.is_slab == "1") {

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
                        url: 'Charge/ExchangeWiseCharges/UpdateExchangeWiseCharges',
                        data: { exchangeWiseCharge: $scope.editExchangeWiseCharges, exchangeWiseChargeSlab: $scope.rowCollection }
                    }).
                    success(function (data) {
                        if (data.success) {
                            $location.path('/ExchangeWiseChargesList');
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
                    url: 'Charge/ExchangeWiseCharges/UpdateExchangeWiseCharges',
                    data: { exchangeWiseCharge: $scope.editExchangeWiseCharges, exchangeWiseChargeSlab: $scope.rowCollection }
                }).
                success(function (data) {
                    if (data.success) {
                        $location.path('/ExchangeWiseChargesList');
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
    };

    $scope.DeleteExchangeSlab = function (row) {
        var index = $scope.rowCollection.indexOf(row);
        if (index !== -1) {
            $scope.rowCollection.splice(index, 1);
        }
    }

    $scope.DeleteExchangeWiseCharge = function (row) {
        var isDelete = confirm("Are you sure you want to delete this charge!");
        if (isDelete == true) {

            $http({
                method: 'POST',
                url: 'Charge/ExchangeWiseCharges/deleteExchangeWiseCharges',
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
        $scope.exchangeWiseCharge = {};

        $scope.rowCollection = [];
        $scope.displayedCollection = [].concat($scope.rowCollection);
        $scope.exchangeWiseCharge = {};

        $scope.editExchangeWiseCharges = {};

        $scope.fldSlab = false;

        $scope.loadCharge();
        $scope.loadSecurityMarket();
    };
})