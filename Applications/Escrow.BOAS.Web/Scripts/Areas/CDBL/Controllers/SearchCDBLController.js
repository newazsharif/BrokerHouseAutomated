angular.module('myApp').controller('SearchCDBLController', function ($scope, $window, $http, $filter, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("--- Search CDBL Transaction");

    $scope.open = function ($event, opened) {
        $event.preventDefault();
        $event.stopPropagation();

        $scope[opened] = true;
    };

    $scope.newSrhCdbl = {};
    $scope.loadDataAndDropdown = function () {
        $scope.newSrhCdbl.from_date = globalvalueservice.getProcessDate();
        $scope.newSrhCdbl.to_date = globalvalueservice.getProcessDate();

        $scope.loadActiveStatus();
        $scope.loadCompany();
        $scope.loadTransactionType();
    };

    $scope.loadActiveStatus = function () {
        $scope.activeStatusList = null;
        $http.get('/CDBL/SearchCDBL/getActiveStatusDdlList/').
          success(function (data) {
              $scope.activeStatusList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadCompany = function () {
        $scope.instrumentList = null;
        $http.get('/CDBL/SearchCDBL/getInstrumentDdlList/').
          success(function (data) {
              $scope.instrumentList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadTransactionType = function () {
        $scope.transactionTypeList = null;
        $http.get('/CDBL/SearchCDBL/getTransactionTypeForSrhCdblDdlList/').
          success(function (data) {
              $scope.transactionTypeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.showHide = function () {
        var display_name = $scope.newSrhCdbl.transaction_type_id;

        if (isundefinedornullservice.isUndefinedOrNull(display_name) && display_name.toString().trim() == "") {
            $scope.newSrhCdbl.fldCompany = false;
            $scope.newSrhCdbl.fldRate = false;
        }
        else if (display_name == "BO Registration") {
            $scope.newSrhCdbl.fldCompany = false;
            $scope.newSrhCdbl.fldRate = false;
        }
        else if (display_name == "Bonus Rights") {
            $scope.newSrhCdbl.fldCompany = true;
            $scope.newSrhCdbl.fldRate = false;
        }
        else {
            $scope.newSrhCdbl.fldCompany = true;
            $scope.newSrhCdbl.fldRate = false;
        }
    };

    $scope.showHide = function () {
        var display_name = $scope.newSrhCdbl.transaction_type_id;

        if (isundefinedornullservice.isUndefinedOrNull(display_name) && display_name.toString().trim() == "") {
            $scope.newSrhCdbl.fldCompany = false;
            $scope.newSrhCdbl.fldRate = false;
        }
        else if (display_name == "BO Registration") {
            $scope.newSrhCdbl.fldCompany = false;
            $scope.newSrhCdbl.fldRate = false;
        }
        else if (display_name == "Bonus Rights") {
            $scope.newSrhCdbl.fldCompany = true;
            $scope.newSrhCdbl.fldRate = false;
        }
        else {
            $scope.newSrhCdbl.fldCompany = true;
            $scope.newSrhCdbl.fldRate = false;
        }
    };

    $scope.loadCdblTable = function () {
        
        $scope.collCollection = null;
        var datefilter = $filter('date');

        var display_name = $scope.newSrhCdbl.transaction_type_id;

        var from_date = datefilter($scope.newSrhCdbl.from_date, 'dd/MM/yyyy');

        var to_date = datefilter($scope.newSrhCdbl.to_date, 'dd/MM/yyyy');

        var isin = $scope.newSrhCdbl.instrument_id;

        var client_id = $scope.newSrhCdbl.client_id;

        var bo_code = $scope.newSrhCdbl.bo_code;

        if(isundefinedornullservice.isUndefinedOrNull(display_name) && display_name.toString().trim() == ""){
            $scope.collCollection = [];
            $scope.rowCollection = [];
            $scope.displayedCollection = [];
        }
        else{
            $http.get('/CDBL/SearchCDBL/getCDBLTableForShr?display_name=' + display_name + '&from_date=' + from_date + '&to_date=' + to_date + '&isin=' + isin + '&client_id=' + client_id + '&bo_code=' + bo_code).
              success(function (data) {
                  $scope.collCollection = data.colNames;
                  $scope.rowCollection = data.rows;
                  $scope.displayedCollection = [].concat($scope.rowCollection);
                  if (display_name == "Bonus Rights") {
                      $scope.newSrhCdbl.fldRate = true;
                  }
                  
              }).
              error(function (data) {
                  
                  toastr.error("Failed Please try again");
              });
        }
    };

    $scope.updateTable = function () {
        var datefilter = $filter('date');

        var display_name = $scope.newSrhCdbl.transaction_type_id;

        var from_date = datefilter($scope.newSrhCdbl.from_date, 'dd/MM/yyyy');

        var to_date = datefilter($scope.newSrhCdbl.to_date, 'dd/MM/yyyy');

        var isin = $scope.newSrhCdbl.instrument_id;

        var client_id = $scope.newSrhCdbl.client_id;

        var bo_code = $scope.newSrhCdbl.bo_code;

        if (isundefinedornullservice.isUndefinedOrNull($scope.newSrhCdbl.market_unit_price)) {
            toastr.error("Please select Unit Price or Market Price!!!");
        }
        else if ($scope.newSrhCdbl.market_unit_price == "Unit Price" && (isundefinedornullservice.isUndefinedOrNull($scope.newSrhCdbl.unit_price) || $scope.newSrhCdbl.unit_price.toString().trim() == "")) {
            toastr.error("Please insert a Unit Price!!!");
        }
        else if ($scope.newSrhCdbl.market_unit_price == "Unit Price") {
            
            $http({
                method: 'POST',
                url: '/CDBL/SearchCDBL/updateBonusRightsUnitPrice',
                data: { unit_price: $scope.newSrhCdbl.unit_price, from_date : from_date, to_date : to_date, isin : isin, client_id : client_id, bo_code : bo_code }
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Updated Successfully");

                    for (var i = 0; i < $scope.displayedCollection.length; i++) {
                        if ($scope.displayedCollection[i]["share transaction type"] == "RIGHTS") {
                            $scope.displayedCollection[i].rate = $scope.newSrhCdbl.unit_price;
                        }
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
        else if ($scope.newSrhCdbl.market_unit_price == "Market Price") {
            
            $http({
                method: 'POST',
                url: '/CDBL/SearchCDBL/updateBonusRightsMarketPrice',
                data: { from_date: from_date, to_date: to_date, isin: isin, client_id: client_id, bo_code: bo_code }
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Updated Successfully");

                    $scope.loadCdblTable();
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