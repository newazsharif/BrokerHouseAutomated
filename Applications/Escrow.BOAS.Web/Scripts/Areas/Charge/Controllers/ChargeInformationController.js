angular.module('myApp').controller('ChargeInformationController', function ($scope, $window, $http, $routeParams, $location, $filter, globalvalueservice, isundefinedornullservice, dateconfigservice, globalvalueservice) {

    $('#pageTitle').text("--- Charge Information");

    $scope.open = function ($event, opened) {
        $event.preventDefault();
        $event.stopPropagation();

        $scope[opened] = true;
    };

    $scope.loadDropdowns = function () {

        $scope.chargeInfo.effective_dt = globalvalueservice.getProcessDate();

        $scope.loadChargeType();
    };


    $scope.loadDropdownsAndInfo = function () {

        $scope.loadChargeType();

        $scope.loadChargeInfoById($routeParams.id);
    };

    $scope.loadChargeInfoById = function (id) {
        $scope.rowCollection = [];
        $http.get('/Charge/ChargeInformation/getChargeInfoById/' + id).
          success(function (data) {
              if (data.success) {
                  $scope.editChargeInfo = data.chargeInfo;
                  if (data.chargeInfo.is_slab == 1) {
                      $scope.rowCollection = data.chargeInfoSlab;
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

    $scope.loadChargeType = function () {
        $scope.chargeTypeList = null;
        $http.get('/Charge/ChargeInformation/getChargeTypeDdlList/').
          success(function (data) {
              $scope.chargeTypeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.showHideSlabForEdit = function () {

        $scope.rowCollection = [];

        var slabList = {};

        if (isundefinedornullservice.isUndefinedOrNull($scope.editChargeInfo.is_slab) || $scope.editChargeInfo.is_slab.toString().trim() == "") {
            slabList = {};

            $scope.rowCollection = [];
            $scope.displayedCollection = [].concat($scope.rowCollection);

            $scope.fldSlab = false;
        }
        else if ($scope.editChargeInfo.is_slab == "0") {
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

    $scope.AddChargeInfoSlabForEdit = function () {

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

    $scope.loadChargeInfoList = function () {
        $scope.rowCollection = [];
        $http.get('/Charge/ChargeInformation/getChargeInfoList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.chargeInfo;
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

    $scope.editChargeInfo = {};
    $scope.editChargeInformation = function () {
        if ($scope.editChargeInfoForm.$valid) {
            var datefilter = $filter('date');

            var effectiveDt = datefilter($scope.editChargeInfo.effective_dt, 'dd/MM/yyyy');

            $scope.editChargeInfo.effective_date = dateconfigservice.FullDateUKtoDateKey(effectiveDt);


            if (isundefinedornullservice.isUndefinedOrNull($scope.editChargeInfo.is_percentage) || $scope.editChargeInfo.is_percentage.toString().trim() == "") {
                $scope.editChargeInfo.is_percentage = 0;
            }

            if (isundefinedornullservice.isUndefinedOrNull($scope.editChargeInfo.is_slab) || $scope.editChargeInfo.is_slab.toString().trim() == "") {
                $scope.editChargeInfo.is_slab = 0;
            }
            else if ($scope.editChargeInfo.is_slab == "1") {

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
                        url: '/Charge/ChargeInformation/UpdateChargeInfo',
                        data: { chargeInfo: $scope.editChargeInfo, chargeInfoSlab: $scope.rowCollection }
                    }).
                    success(function (data) {
                        if (data.success) {
                            $location.path('/ChargeInformationList');
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
                    url: '/Charge/ChargeInformation/UpdateChargeInfo',
                    data: { chargeInfo: $scope.editChargeInfo, chargeInfoSlab: $scope.rowCollection }
                }).
                success(function (data) {
                    if (data.success) {
                        $location.path('/ChargeInformationList');
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

    $scope.DeleteChargeInfoSlab = function (row) {
        var index = $scope.rowCollection.indexOf(row);
        if (index !== -1) {
            $scope.rowCollection.splice(index, 1);
        }
    }

    $scope.refresh = function () {
        $scope.chargeInfo = {};

        $scope.rowCollection = [];
        $scope.displayedCollection = [].concat($scope.rowCollection);
        $scope.chargeInfo = {};

        $scope.rowCollection = [];
        $scope.displayedCollection = [].concat($scope.rowCollection);
        $scope.editChargeInfo = {};

        $scope.fldSlab = false;

        $scope.loadChargeType();
    };
})