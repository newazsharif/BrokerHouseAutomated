angular.module('myApp').
controller('PayInOutController', function ($scope, $window, $http, $location, $routeParams, dropdownservice, dateconfigservice, $filter, globalvalueservice, Upload, $q, $timeout) {
    $scope.LoadAllDropDown = function()
    {
        $scope.PayInOut = {};
        $scope.PayInOut.isInOut = 'I';
        $scope.PayInOut.trd_dt = globalvalueservice.getProcessDate();
        $scope.loadStockExchange();
        $scope.setPayinOutPath();
    }
    $scope.loadStockExchange = function () {
        $http.get('/CDBL/PayInOut/GetddlStockExchange')
        .success(function (data) {
            $scope.StockList = data.data;
            debugger;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };
    $scope.setPayinOutPath = function()
    {
        $http.get('/CDBL/PayInOut/SetPayinOutPath')
        .success(function (data) {
            $scope.PayinOutPath = data.data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    }

    $scope.ExportPayInOut = function()
    {
        var inputDate = dateconfigservice.FullDateUKtoDateKey($scope.PayInOut.trd_dt);
        $('.loader').show();
        $http.get('/CDBL/PayInOut/ExportPayInOut?isPayinPayout='+$scope.PayInOut.isInOut+'&trd_dt=' + inputDate)
    .   success(function (data) {
        if (data.success) {
            toastr.success(data.message);
            $('.loader').hide();
        }
        else
        {
            toastr.error(data.message)
            $('.loader').hide();
        }
                
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
        toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
        
        
    }

})




