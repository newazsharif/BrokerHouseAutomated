angular.module('myApp').controller('PaymentApproveController', function ($scope, $window, $http, globalvalueservice) {

    $('#pageTitle').text("--- Payment Approve");

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
                approveFundPayment$scope.totalSelectedAmount += collection[i].amount;
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
            for (var i = 0; i < $scope.displayedCollection.length; i++) {
                if ($scope.displayedCollection[i].id == id) {
                    $scope.totalSelectedAmount += $scope.displayedCollection[i].amount;
                }
                if ($scope.displayedCollection[i].id == 0) {
                    $scope.selected.push(0);
                }
                else if ($scope.displayedCollection[i].id == id) {
                    $scope.selected.push(id);
                }
            }
        }

        else {
            for (var i = 0; i < $scope.displayedCollection.length; i++) {
                if ($scope.displayedCollection[i].id == id) {
                    $scope.totalSelectedAmount -= $scope.displayedCollection[i].amount;
                }
                if ($scope.displayedCollection[i].id == 0) {
                    $scope.selected.splice($scope.selected.indexOf(0), 1);
                }
                else if ($scope.displayedCollection[i].id == id) {
                    $scope.selected.splice($scope.selected.indexOf(id), 1);
                }
            }
        }

    }

    $scope.changeRowIdVal = function (row) {
        var index = $scope.rowCollection.indexOf(row);
        $scope.rowCollection[index].id = 0;
    }

    $scope.loadPaymentApproveList = function () {
        $http.get('/Transaction/PaymentApprove/getPaymentApproveList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.paymentApproveList;
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

    $scope.approveFundPayment = function () {
        if ($scope.selected.length == 0) {
            toastr.error("Please select a fund payment to approve!!!!");
        }
        else {

            var selected = [];

            for (var i = 0; i < $scope.selected.length; i++) {
                if ($scope.selected[i] != 0) {
                    selected.push($scope.selected[i]);
                }
            }

            $http({
                method: 'POST',
                url: '/Transaction/PaymentApprove/approveFundPayment',
                data: selected
            }).success(function (data) {
                if (data.success) {
                    if (data.data) {
                        toastr.error(data.data);
                        $scope.loadPaymentApproveList();
                        $scope.selected = [];
                        $scope.totalSelectedAmount = 0;
                    }else{
                    toastr.success("Approved Successfully");
                    $scope.loadPaymentApproveList();
                    $scope.selected = [];
                    $scope.totalSelectedAmount = 0;
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
};
})