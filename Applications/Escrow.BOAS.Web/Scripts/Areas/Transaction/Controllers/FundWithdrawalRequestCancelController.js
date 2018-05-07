﻿angular.module('myApp').controller('FundWithdrawalRequestCancelController', function ($scope, $window, $http, globalvalueservice) {

    $('#pageTitle').text("--- Withdrawal Request Cancel");

    $scope.totalSelectedAmount = 0;

    $scope.selected = [];

    // Function to get data for all selected items
    $scope.selectAll = function (collection) {

        // if there are no items in the 'selected' array, 
        // push all elements to 'selected'
        if ($scope.selected.length === 0) {

            $scope.totalSelectedAmount = 0;
            for (var i = 0; i < collection.length; i++) {
                $scope.selected.push(collection[i].id);
                $scope.totalSelectedAmount += collection[i].amount;
            }

            // if there are items in the 'selected' array, 
            // add only those that ar not
        } else if ($scope.selected.length > 0 && $scope.selected.length != $scope.displayedCollection.length) {

            for (var i = 0; i < collection.length; i++) {
                var found = $scope.selected.indexOf(collection[i].id);
                if (found == -1) {
                    $scope.selected.push(collection[i].id);
                    $scope.totalSelectedAmount += collection[i].amount;
                }
            }

            // Otherwise, remove all items
        } else {

            $scope.selected = [];
            $scope.totalSelectedAmount = 0;

        }

    };

    // Function to get data by selecting a single row
    $scope.select = function (id) {

        var found = $scope.selected.indexOf(id);

        if (found == -1) {
            $scope.selected.push(id);

            for (var i = 0; i < $scope.displayedCollection.length; i++) {
                if ($scope.displayedCollection[i].id == id)
                    $scope.totalSelectedAmount += $scope.displayedCollection[i].amount;
            }
        }

        else {
            $scope.selected.splice(found, 1);

            for (var i = 0; i < $scope.displayedCollection.length; i++) {
                if ($scope.displayedCollection[i].id == id)
                    $scope.totalSelectedAmount -= $scope.displayedCollection[i].amount;
            }
        }

    }

    $scope.loadWithdrawalReqCancelList = function () {
        $http.get('/Transaction/FundWithdrawalRequestCancel/getWithdrawalReqCancelList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.withdrawalReqCancelList;
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

    $scope.cancelFndWithdrawalRequest = function () {
        if ($scope.selected.length == 0) {
            toastr.error("Please select a fund payment to cancel!!!!");
        }
        else {
            $http({
                method: 'POST',
                url: '/Transaction/FundWithdrawalRequestCancel/cancelFndWithdrawalReq',
                data: $scope.selected
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Canceled Successfully");
                    $scope.loadWithdrawalReqCancelList();
                    $scope.selected = [];
                    $scope.totalSelectedAmount = 0;
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