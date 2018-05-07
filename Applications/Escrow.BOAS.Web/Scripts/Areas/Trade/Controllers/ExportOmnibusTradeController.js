angular.module('myApp').
controller('ExportOmnibusTradeController', function ($scope, $window, $http, $location, $routeParams, dropdownservice, dateconfigservice, $filter, globalvalueservice, Upload, $q, $timeout) {
    $scope.LoadAllDropDown = function () {
        $scope.ExportOmnibusTrade = {};
        $scope.ExportOmnibusTrade.isTxtOrXml = 'T';
        $scope.ExportOmnibusTrade.trd_dt = globalvalueservice.getProcessDate();
        $scope.loadStockExchange();
        $scope.LoadExportPath();
        $scope.loadOmnibusMaster();
    };
    $scope.open = function ($event, opened) {
        $event.preventDefault();
        $event.stopPropagation();

        $scope[opened] = true;

    };
    $scope.LoadExportPath = function () {
        $http.get('/Trade/ExportTrade/LoadExportPath')
        .success(function (data) {
            $scope.ExportOmnibusTrade.exportTradePath = data;
        }).error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };

    $scope.loadOmnibusMaster = function () {
        $http.get('/Trade/ExportTrade/GetddlOmnibusMaster')
        .success(function (data) {
            $scope.OmnibusMasterList = data.data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };
    $scope.loadStockExchange = function () {
        $http.get('/Trade/ExportTrade/GetddlStockExchange')
        .success(function (data) {
            $scope.StockList = data.data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };

    $scope.ExportOmnibusTradeData = function () {
        if ($scope.ExportOmnibusTradeForm.$valid) {
            $('.loader').show();
            var datefilter = $filter('date');
            $scope.ExportOmnibusTrade.trd_dt = datefilter($scope.ExportOmnibusTrade.trd_dt, 'dd/MM/yyyy');
            $scope.ExportOmnibusTrade.trd_dt = dateconfigservice.FullDateUKtoDateKey($scope.ExportOmnibusTrade.trd_dt);
            $http.get('/Trade/ExportTrade/ExportOmnibusTradeData?stock_exchange_id=' + $scope.ExportOmnibusTrade.stock_Exchange + '&trd_dt=' + $scope.ExportOmnibusTrade.trd_dt + '&omnibus_master_id=' + $scope.ExportOmnibusTrade.omnibus_master_id + '&isTxtOrXml=' + $scope.ExportOmnibusTrade.isTxtOrXml)
            .success(function (data) {
                if (data.success) {
                    toastr.success(data.message);
                    $('.loader').hide();
                }
                else {
                    toastr.error(data.message);
                    $('.loader').hide();
                    $scope.ExportOmnibusTrade.trd_dt = globalvalueservice.getProcessDate();
                }
            })
            .error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
                $('.loader').hide();
            });
        }
    }
});


