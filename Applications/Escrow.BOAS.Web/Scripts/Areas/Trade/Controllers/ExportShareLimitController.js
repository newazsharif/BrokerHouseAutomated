angular.module('myApp').controller('ExportShareLimitController', function ($scope, $window, $http, $location, $routeParams, $filter, dateconfigservice, isundefinedornullservice, globalvalueservice) {

    $('#pageTitle').text("--- Export Share Limit");

    $scope.expShareLimit = {};

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

    $scope.loadExpShareLimitList = function () {
        $scope.rowCollection = [];
        $http.get('/Trade/ExportShareLimit/getShareLimitList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.exportLogList;
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

    $scope.loadImportShareLimitList = function () {
        $scope.rowCollection = [];
        $http.get('/Trade/ExportShareLimit/getImpShareLimitList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.importShareLimitList;
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

    $scope.loadShareLimit = function () {

        $scope.expShareLimit.export_date = globalvalueservice.getProcessDate();

        $scope.loadFileFor();

        $scope.loadImportShareLimitList();
    };

    $scope.loadFileFor = function () {
        $scope.fileForList = [
      { value: 'Morning', text: 'Morning' },
      { value: 'Intraday', text: 'Intraday' }
        ];
    };

    $scope.exportShareLimit = function () {

        if ($scope.expShareLimitForm.$valid) {
            
            var datefilter = $filter('date');

            var expDate = datefilter($scope.expShareLimit.export_date, 'dd/MM/yyyy');

            $scope.expShareLimit.export_dt = dateconfigservice.FullDateUKtoDateKey(expDate);

            $http({
                method: 'POST',
                url: '/Trade/ExportShareLimit/expShareLimitToServer',
                data: { expShareLimit: $scope.expShareLimit, selected: $scope.selected }
            }).success(function (data) {
                if (data.success) {
                    
                    toastr.success("Exported Successfully");
                    $scope.loadShareLimit();
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

    $scope.refresh = function () {
        $scope.loadShareLimit();
    };
})