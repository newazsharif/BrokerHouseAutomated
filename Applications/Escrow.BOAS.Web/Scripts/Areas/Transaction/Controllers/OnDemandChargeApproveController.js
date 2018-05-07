angular.module('myApp').controller('OnDemandChargeApproveController', function ($scope, $window, $http, globalvalueservice) {

    $('#pageTitle').text("--- On Demand Charge Approve");

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

    $scope.loadOnDemCharApproveList = function () {
        
        $http.get('/Transaction/OnDemandChargeApprove/getOnDemCharApproveList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.onDemCharApproveList;
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

    $scope.approveOnDemChar = function () {
        if ($scope.selected.length == 0) {
            toastr.error("Please select a on demand charge to approve!!!!");
        }
        else {
            
            var transaction_dates = "";
            var charge_ids = "";
            var transaction_type_ids = "";

            for (var i = 0; i < $scope.selected.length; i++) {
                for (var j = 0; j < $scope.displayedCollection.length; j++) {
                    if ($scope.selected[i] == $scope.displayedCollection[j].id) {
                        transaction_dates = transaction_dates + $scope.displayedCollection[j].transaction_date + ","
                        charge_ids = charge_ids + $scope.displayedCollection[j].charge_id + ","
                        transaction_type_ids = transaction_type_ids + $scope.displayedCollection[j].transaction_type_id + ","
                        break;
                    }
                }
            }

            $http({
                method: 'POST',
                url: '/Transaction/OnDemandChargeApprove/approveOnDemChar',
                data: { transaction_dates: transaction_dates, charge_ids: charge_ids, transaction_type_ids: transaction_type_ids }
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Approved Successfully");
                    $scope.loadOnDemCharApproveList();
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