angular.module('myApp').controller('BranchWiseChargesController', function ($scope, $window, $http, $routeParams, $location, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("--- Branch Wise Charges");


    $scope.loadDropdowns = function () {

        $scope.loadCharge();
        $scope.loadBranch();
    };


    $scope.loadDropdownsAndInfo = function () {

        $scope.loadCharge();
        $scope.loadBranch();

        $scope.loadBranchWiseChargeById($routeParams.id);
    };

    $scope.loadBranchWiseChargeById = function (id) {
        $scope.rowCollection = [];
        $http.get('Charge/BranchWiseCharges/getBranchWiseChargeById/' + id).
          success(function (data) {
              if (data.success) {
                  $scope.editBranchWiseCharges = data.branchWiseCharge;
                  if (data.branchWiseCharge.is_slab == 1) {
                      $scope.rowCollection = data.branchWiseChargeSlab;
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
        $http.get('Charge/BranchWiseCharges/getChargeDdlList/').
          success(function (data) {
              $scope.chargeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadBranch = function () {
        $scope.branchList = null;
        $http.get('/Charge/BranchWiseCharges/getBranchDdlList/').
          success(function (data) {
              $scope.branchList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.showHideSlab = function () {

        $scope.rowCollection = [];

        var slabList = {};

        if (isundefinedornullservice.isUndefinedOrNull($scope.branchWiseCharge.is_slab) || $scope.branchWiseCharge.is_slab.toString().trim() == "") {
            slabList = {};

            $scope.rowCollection = [];
            $scope.displayedCollection = [].concat($scope.rowCollection);
        }
        else if ($scope.branchWiseCharge.is_slab == "0") {
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

        if (isundefinedornullservice.isUndefinedOrNull($scope.editBranchWiseCharges.is_slab) || $scope.editBranchWiseCharges.is_slab.toString().trim() == "") {
            slabList = {};

            $scope.rowCollection = [];
            $scope.displayedCollection = [].concat($scope.rowCollection);

            $scope.fldSlab = false;
        }
        else if ($scope.editBranchWiseCharges.is_slab == "0") {
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

    $scope.AddBranchSlab = function () {

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

    $scope.AddBranchSlabForEdit = function () {

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

    $scope.loadBranchWiseChargeList = function () {
        $scope.rowCollection = [];
        $http.get('Charge/BranchWiseCharges/getBranchWiseChargesList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.branchWiseCharge;
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

    $scope.branchWiseCharge = {};
    $scope.addCharge = function () {
        if ($scope.newBranchWiseChargeForm.$valid) {
            if (isundefinedornullservice.isUndefinedOrNull($scope.branchWiseCharge.is_percentage) || $scope.branchWiseCharge.is_percentage.toString().trim() == "") {
                $scope.branchWiseCharge.is_percentage = 0;
            }
            if (isundefinedornullservice.isUndefinedOrNull($scope.branchWiseCharge.is_slab) || $scope.branchWiseCharge.is_slab.toString().trim() == "") {
                $scope.branchWiseCharge.is_slab = 0;
            }
            else if ($scope.branchWiseCharge.is_slab == "1") {

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
                        url: 'Charge/BranchWiseCharges/AddBranchWiseCharges',
                        data: { branchWiseCharge: $scope.branchWiseCharge, branchWiseChargeSlab: $scope.rowCollection }
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
                    url: 'Charge/BranchWiseCharges/AddBranchWiseCharges',
                    data: { branchWiseCharge: $scope.branchWiseCharge, branchWiseChargeSlab: $scope.rowCollection }
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

    $scope.editBranchWiseCharges = {};
    $scope.editCharge = function () {
        if ($scope.editBranchWiseChargeForm.$valid) {
            if (isundefinedornullservice.isUndefinedOrNull($scope.editBranchWiseCharges.is_percentage) || $scope.editBranchWiseCharges.is_percentage.toString().trim() == "") {
                $scope.editBranchWiseCharges.is_percentage = 0;
            }

            if (isundefinedornullservice.isUndefinedOrNull($scope.editBranchWiseCharges.is_slab) || $scope.editBranchWiseCharges.is_slab.toString().trim() == "") {
                $scope.editBranchWiseCharges.is_slab = 0;
            }
            else if ($scope.editBranchWiseCharges.is_slab == "1") {

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
                        url: 'Charge/BranchWiseCharges/UpdateBranchWiseCharges',
                        data: { branchWiseCharge: $scope.editBranchWiseCharges, branchWiseChargeSlab: $scope.rowCollection }
                    }).
                    success(function (data) {
                        if (data.success) {
                            $location.path('/BranchWiseChargesList');
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
                    url: 'Charge/BranchWiseCharges/UpdateBranchWiseCharges',
                    data: { branchWiseCharge: $scope.editBranchWiseCharges, branchWiseChargeSlab: $scope.rowCollection }
                }).
                success(function (data) {
                    if (data.success) {
                        $location.path('/BranchWiseChargesList');
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

    $scope.DeleteBranchSlab = function (row) {
        var index = $scope.rowCollection.indexOf(row);
        if (index !== -1) {
            $scope.rowCollection.splice(index, 1);
        }
    }

    $scope.DeleteBranchWiseCharge = function (row) {
        var isDelete = confirm("Are you sure you want to delete this charge!");
        if (isDelete == true) {

            $http({
                method: 'POST',
                url: 'Charge/BranchWiseCharges/deleteBranchWiseCharges',
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
        $scope.branchWiseCharge = {};

        $scope.rowCollection = [];
        $scope.displayedCollection = [].concat($scope.rowCollection);
        $scope.branchWiseCharge = {};

        $scope.editBranchWiseCharges = {};

        $scope.fldSlab = false;

        $scope.loadCharge();
        $scope.loadBranch();
    };
})