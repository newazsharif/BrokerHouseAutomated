angular.module('myApp').controller('ExportCashLimitController', function ($scope, $window, $http, $location, $routeParams, $filter, dateconfigservice, isundefinedornullservice, globalvalueservice) {

    $('#pageTitle').text("--- Export Cash Limit");

    $scope.expCsLimit = {};

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

    $scope.loadImportCashLimitList = function () {
        $scope.rowCollection = [];
        $http.get('/Trade/ExportCashLimit/getImpCashLimitList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.importCashLimitList;
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

    $scope.loadExpCsLimitList = function () {
        $scope.rowCollection = [];
        $http.get('/Trade/ExportCashLimit/getCsLimitList/').
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

    $scope.loadCashLimit = function () {

        $scope.expCsLimit.export_date = globalvalueservice.getProcessDate();

        $scope.loadFileFor();

        $scope.loadImportCashLimitList();

        $scope.deactivateShowHide = true;
    };

    $scope.loadFileFor = function () {
        $scope.fileForList = [
      { value: 'Morning', text: 'Morning' },
      { value: 'Intraday', text: 'Intraday' }
        ];
    };

    $scope.showHideIsDeactivate = function () {

        if (isundefinedornullservice.isUndefinedOrNull($scope.expCsLimit.file_for) || $scope.expCsLimit.file_for.toString().trim() == "" || $scope.expCsLimit.file_for.toString().trim() == "Morning") {
            $scope.deactivateShowHide = true;
        }
        else {
            $scope.deactivateShowHide = false;
        }
    };

    $scope.exportCashLimit = function () {

        if ($scope.expCsLimitForm.$valid) {
            
            var datefilter = $filter('date');

            var expDate = datefilter($scope.expCsLimit.export_date, 'dd/MM/yyyy');

            $scope.expCsLimit.export_dt = dateconfigservice.FullDateUKtoDateKey(expDate);

            if (isundefinedornullservice.isUndefinedOrNull($scope.expCsLimit.is_deactive_all) || $scope.expCsLimit.is_deactive_all.toString().trim() == "") {
                $scope.expCsLimit.is_deactive_all = 0;
            }
            $http({
                method: 'POST',
                url: '/Trade/ExportCashLimit/expCsLimitToServer',
                data: { expCsLimit : $scope.expCsLimit, selected: $scope.selected }
            }).success(function (data) {
                if (data.success) {
                    
                    toastr.success("Exported Successfully");
                    $scope.loadCashLimit();
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
        $scope.loadCashLimit();
    };
})