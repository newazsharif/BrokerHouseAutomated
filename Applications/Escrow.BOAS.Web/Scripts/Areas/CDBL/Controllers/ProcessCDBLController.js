angular.module('myApp').controller('ProcessCDBLController', function ($scope, $window, $http, $filter, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("--- Process CDBL Transaction");

    $scope.showErrorModal = false;

    $scope.open = function ($event, opened) {
        $event.preventDefault();
        $event.stopPropagation();

        $scope[opened] = true;
    };

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

    $scope.loadCDBLFileList = function () {
        $scope.from_date = globalvalueservice.getProcessDate();
        $scope.to_date = globalvalueservice.getProcessDate();

        $http.get('/CDBL/ProcessCDBL/getCDBLFileList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.CDBLFileList;
                  $scope.displayedCollection = [].concat($scope.rowCollection);
                  $scope.cdbl_file_path = data.cdbl_file_path;
              }
              else {
                  toastr.error(data.errorMessage);
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.processCDBLFiles = function () {
        if ($scope.selected.length == 0) {
            toastr.error("Please select files to process!!!!");
        }
        else {
            
            var datefilter = $filter('date');
            var from_date = datefilter($scope.from_date, 'dd/MM/yyyy');
            var to_date = datefilter($scope.to_date, 'dd/MM/yyyy');
            $http({
                method: 'POST',
                url: '/CDBL/ProcessCDBL/processCDBLTrans',
                data: { selected: $scope.selected, from_date: from_date, to_date: to_date }
            }).success(function (data) {
                if (data.success) {
                    
                    toastr.success("Process Successfully");
                }
                else if (data.errorType == "list") {
                    
                    $scope.errorRowCollection = [];
                    $scope.errorRowCollection = data.errorList;
                    $scope.errorDisplayedCollection = [].concat($scope.errorRowCollection);
                    $scope.showErrorModal = !$scope.showErrorModal;
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