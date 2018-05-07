angular.module('myApp').controller('PendingOrderController', function ($rootScope, $scope, $window, $http, $filter, globalvalueservice) {

    $rootScope.$watch("pending", function (newValue, oldValue) {
        if (newValue != oldValue) {
            $scope.loadPendingOrderList();
        }
    });

    $('#pageTitle').text("--- Pending Order");

    $scope.selected = [];

    // Function to get data for all selected items
    $scope.selectAll = function (collection) {
        // if there are no items in the 'selected' array, 
        // push all elements to 'selected'
        if ($scope.selected.length === 0) {

            $scope.totalSelectedAmount = 0;
            for (var i = 0; i < collection.length; i++) {
                $scope.selected.push(collection[i].id);
            }

            // if there are items in the 'selected' array, 
            // add only those that ar not
        } else if ($scope.selected.length > 0 && $scope.selected.length != $scope.displayedCollection.length) {

            for (var i = 0; i < collection.length; i++) {
                var found = $scope.selected.indexOf(collection[i].id);
                if (found == -1) {
                    $scope.selected.push(collection[i].id);
                }
            }

            // Otherwise, remove all items
        } else {

            $scope.selected = [];
        }

    };

    // Function to get data by selecting a single row
    $scope.select = function (id) {
        var found = $scope.selected.indexOf(id);

        if (found == -1) {
            $scope.selected.push(id);
        }

        else {
            $scope.selected.splice(found, 1);
        }

    }

    $scope.loadPendingOrderList = function () {
        $http.get('/Order/PendingOrder/getPendingOrderList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.pendingOrderList;
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

    $scope.orderPlaced = function () {
        if ($scope.selected.length == 0) {
            toastr.error("Please select a order to place!!!!");
        }
        else {
            var selected = $scope.selected;
            $http({
                method: 'POST',
                url: '/Order/PendingOrder/orderPlaced',
                data: selected
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Approved Successfully");
                    $scope.loadPendingOrderList();
                    $scope.selected = [];
                }
                else {
                    toastr.error(data.errorMessage);
                }
            }).
            error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
        }
    };

    $scope.orderCancel = function () {
        if ($scope.selected.length == 0) {
            toastr.error("Please select a order to place!!!!");
        }
        else {
            var selected = $scope.selected;
            $http({
                method: 'POST',
                url: '/Order/PendingOrder/orderCancel',
                data: selected
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Canceled Successfully");
                    $scope.loadPendingOrderList();
                    $scope.selected = [];
                }
                else {
                    toastr.error(data.errorMessage);
                }
            }).
            error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
        }
    };
})