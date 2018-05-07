﻿angular.module('myApp').controller('SubAccountChargesController', function ($scope, $window, $http, $routeParams, $location, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("--- Sub Account Charges");


    $scope.loadDropdowns = function () {

        $scope.loadCharge();
        $scope.loadSubAccountType();
    };


    $scope.loadDropdownsAndInfo = function () {

        $scope.loadCharge();
        $scope.loadSubAccountType();

        $scope.loadSubAccChargeById($routeParams.id);
    };

    $scope.loadSubAccChargeById = function (id) {
        $scope.rowCollection = [];
        $http.get('Charge/SubAccountCharges/getSubAccChargeById/' + id).
          success(function (data) {
              if (data.success) {
                  $scope.editSubAccCharges = data.subAccCharge;
                  if (data.subAccCharge.is_slab == 1) {
                      $scope.rowCollection = data.subAccChargeSlab;
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
        $http.get('Charge/SubAccountCharges/getChargeDdlList/').
          success(function (data) {
              $scope.chargeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadSubAccountType = function () {
        $scope.subAccountList = null;
        $http.get('Charge/SubAccountCharges/getSubAccountDdlList/').
          success(function (data) {
              $scope.subAccountList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.showHideSlab = function () {

        $scope.rowCollection = [];

        var slabList = {};

        if (isundefinedornullservice.isUndefinedOrNull($scope.subAccCharges.is_slab) || $scope.subAccCharges.is_slab.toString().trim() == "") {
            slabList = {};

            $scope.rowCollection = [];
            $scope.displayedCollection = [].concat($scope.rowCollection);
        }
        else if ($scope.subAccCharges.is_slab == "0") {
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

        if (isundefinedornullservice.isUndefinedOrNull($scope.editSubAccCharges.is_slab) || $scope.editSubAccCharges.is_slab.toString().trim() == "") {
            slabList = {};

            $scope.rowCollection = [];
            $scope.displayedCollection = [].concat($scope.rowCollection);

            $scope.fldSlab = false;
        }
        else if ($scope.editSubAccCharges.is_slab == "0") {
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

    $scope.AddSubAccSlab = function () {

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

    $scope.AddSubAccSlabForEdit = function () {

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

    $scope.loadSubAccChargeList = function () {
        $scope.rowCollection = [];
        $http.get('Charge/SubAccountCharges/getSubAccChargesList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.subAccCharge;
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

    $scope.subAccCharges = {};
    $scope.addCharge = function () {
        if ($scope.newSubAccChargeForm.$valid) {
            if (isundefinedornullservice.isUndefinedOrNull($scope.subAccCharges.is_percentage) || $scope.subAccCharges.is_percentage.toString().trim() == "") {
                $scope.subAccCharges.is_percentage = 0;
            }

            if (isundefinedornullservice.isUndefinedOrNull($scope.subAccCharges.is_slab) || $scope.subAccCharges.is_slab.toString().trim() == "") {
                $scope.subAccCharges.is_slab = 0;
            }
            else if ($scope.subAccCharges.is_slab == "1") {

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
                        url: 'Charge/SubAccountCharges/AddSubAccCharges',
                        data: { subAccCharge: $scope.subAccCharges, subAccChargeSlab: $scope.rowCollection }
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
                    url: 'Charge/SubAccountCharges/AddSubAccCharges',
                    data: { subAccCharge: $scope.subAccCharges, subAccChargeSlab: $scope.rowCollection }
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

    $scope.editSubAccCharges = {};
    $scope.editCharge = function () {
        if ($scope.editSubAccChargeForm.$valid) {
            if (isundefinedornullservice.isUndefinedOrNull($scope.editSubAccCharges.is_percentage) || $scope.editSubAccCharges.is_percentage.toString().trim() == "") {
                $scope.editSubAccCharges.is_percentage = 0;
            }

            if (isundefinedornullservice.isUndefinedOrNull($scope.editSubAccCharges.is_slab) || $scope.editSubAccCharges.is_slab.toString().trim() == "") {
                $scope.editSubAccCharges.is_slab = 0;
            }
            else if ($scope.editSubAccCharges.is_slab == "1") {

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
                        url: 'Charge/SubAccountCharges/UpdateSubAccCharges',
                        data: { subAccCharge: $scope.editSubAccCharges, subAccChargeSlab: $scope.rowCollection }
                    }).
                    success(function (data) {
                        if (data.success) {
                            $location.path('/SubAccountChargesList');
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
                    url: 'Charge/SubAccountCharges/UpdateSubAccCharges',
                    data: { subAccCharge: $scope.editSubAccCharges, subAccChargeSlab: $scope.rowCollection }
                }).
                success(function (data) {
                    if (data.success) {
                        $location.path('/SubAccountChargesList');
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

    $scope.DeleteSubAccSlab = function (row) {
        var index = $scope.rowCollection.indexOf(row);
        if (index !== -1) {
            $scope.rowCollection.splice(index, 1);
        }
    }

    $scope.DeleteSubAccCharge = function (row) {
        var isDelete = confirm("Are you sure you want to delete this charge!");
        if (isDelete == true) {

            $http({
                method: 'POST',
                url: 'Charge/SubAccountCharges/deleteSubAccCharges',
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
        $scope.subAccCharges = {};

        $scope.rowCollection = [];
        $scope.displayedCollection = [].concat($scope.rowCollection);
        $scope.subAccCharges = {};

        $scope.editSubAccCharges = {};

        $scope.fldSlab = false;

        $scope.loadCharge();
        $scope.loadSubAccountType();
    };
})