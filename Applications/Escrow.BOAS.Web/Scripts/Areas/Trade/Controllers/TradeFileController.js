angular.module('myApp').
controller('TradeFileController', function ($scope, $window, $http, $location, $routeParams, dropdownservice, dateconfigservice, $filter, globalvalueservice, Upload,$q,$timeout) {
    $scope.showErrorModal = false;

    $scope.initialLoad = function () {
        //debugger;
        $scope.trade = {};
        $scope.Filedate = '';
        $scope.TradeList = {};
        $scope.trade.trd_dt = globalvalueservice.getProcessDate();
        var datefilter = $filter('date');
        $scope.ProcessdateUK = datefilter(globalvalueservice.getProcessDate(), 'dd/MM/yyyy');
        $scope.ProcessdateUK = dateconfigservice.FullDateUKtoDateKey($scope.ProcessdateUK);
        $scope.isClosePriceExecuted();
        $scope.loadStockExchange();
        $scope.isTradeUploaded();
        $scope.GetTradeFileDate();
        //$scope.isTradeFileAlreadyExecuted();


    };

    $scope.isClosePriceExecuted = function () {
       
        $http.get('/Trade/Trade/isClosePriceExecuted?processDate=' + $scope.ProcessdateUK)
        .success(function (data) {
            if (data.data == true) {
                $scope.buttonDisabled = false;
                $scope.UploadDisabled = false;
            }
            else {
                $scope.buttonDisabled = true;
                $scope.UploadDisabled = true;
                toastr.error('You have to execute Close Price File First!!!!!');
            }
        })
    };

    $scope.isTradeUploaded = function () {
        $http.get('/Trade/Trade/isTradeUploaded')
        .success(function (data) {
            $scope.tradeUploaded = data;
            if ($scope.tradeUploaded == true) {
                toastr.warning('Trade Already Uploaded For Edit');
                //$scope.UploadDisabled = true;
            }
        });
    };
    
    $scope.loadStockExchange = function () {

        $http.get('/Trade/Trade/GetddlStockExchange')
        .success(function (data) {
            $scope.StockList = data.data;
            debugger;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    }
    $scope.UploadTradeFile = function (xmlFile) {
        //alert(dropdownservice.getSelectedText($scope.StockList, $scope.trade.stock_exchange_id));

        if ((dropdownservice.getSelectedText($scope.StockList, $scope.trade.stock_exchange_id) == 'Dhaka Stock Exchange Limited') && ($('#FileUpload').val().substr($('#FileUpload').val().length - 4) != '.xml')) {
            toastr.warning('Please select xml file for DSE');
        }
        else if ((dropdownservice.getSelectedText($scope.StockList, $scope.trade.stock_exchange_id) == 'Chittagong Stock Exchange Limited') && ($('#FileUpload').val().substr($('#FileUpload').val().length - 4) != '.txt')) {
            toastr.warning('Please select txt file for CSE');
        }
        else {
            $(".loader").show();
            var tempFile = [];
            tempFile[0] = xmlFile;
            Upload.upload(
                   {
                       url: '/Trade/Trade/UploadTradeFile',
                       method: 'POST',
                       fields: $scope.trade,
                       file: tempFile,
                       async: true
                   }).success(function (data) {
                       $scope.GetTradeFileDate();
                       $scope.isTradeFileAlreadyExecuted();
                       if (data.invalidInvestors != null) {

                           $scope.errorRowCollection = [];
                           $scope.errorRowCollection = data.invalidInvestors;
                           $scope.errorDisplayedCollection = [].concat($scope.errorRowCollection);
                           $scope.showErrorModal = true;
                           $(".loader").hide();
                       }
                       else {
                           $scope.showErrorModal = false;
                           $(".loader").hide();
                           if (data.data == 'failed')
                           {
                               toastr.error(data.errorMessage);
                           }
                           toastr.success('File Uploaded Successfully!!!!');
                       }
                       //$scope.LoadTradeList();

                   }).error(function (XMLHttpRequest, textStatus, errorThrown) {
                       toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
                   });
        }
    };

    $scope.LoadTradeList = function () {
        $http.get('/Trade/Trade/LoadTradeList?stock_exchange_id=' + $routeParams.id)
        .success(function (data) {
            $scope.TradeList = data.data;

        })
        .error(function () {
            toastr.error('Cannot Load Trade Data');
        })
    };

    $scope.ExecuteTradeFile = function () {

        if ($scope.TradeFileForm.$valid) {
            //$scope.isTradeFileAlreadyExecuted()
            //.then(function () {
                //var trade_date = dateconfigservice.FullDateUKtoDateKey($scope.trade.trd_dt);
                //if (trade_date != $scope.Filedate) {
                //    toastr.error('File date and process date are not same!!!');
                //    //$scope.trade.trd_dt = globalvalueservice.getProcessDate();
                //}
                //else if ($scope.executed == 1) {
                //    toastr.error('This file Already been Executed!!!');
                //}
                
                    //$scope.trade.trd_dt = globalvalueservice.getProcessDate();
                    $('.loader').show();
                    $http({
                        method: 'POST',
                        url: '/Trade/Trade/ExecuteTradeFile',
                        data: $scope.trade
                    }).success(function (data) {
                        if (data.success) {
                            toastr.success("Executed Successfully");
                            $('.loader').hide();

                        }
                        else {
                            toastr.error(data);
                            $('.loader').hide();
                        }
                    }).
                   error(function (XMLHttpRequest, textStatus, errorThrown) {
                       toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
                   });
                
            //});
            //var datefilter = $filter('date');
            //$scope.trade.trd_dt = datefilter($scope.trade.trd_dt, 'dd/MM/yyyy');
            
        }
    };

    $scope.isTradeFileAlreadyExecuted = function () {
        var inputDate = dateconfigservice.FullDateUKtoDateKey($scope.trade.trd_dt);
        var deferred = $q.defer();
        $scope.executed = 0;
        $timeout(function (result) {
            $http.get('/Trade/Trade/isTradeFileAlreadyExecuted?checkId=' + inputDate)
            .success(function (data) {
            if (data.executed == true) {
                $scope.executed = 1;
                deferred.resolve();
            }
            else {
                $scope.executed = 0;
                deferred.resolve();
            }
            
            });
        }, 1000);
        return deferred.promise;
        
    };

   
    $scope.GetTradeFileDate = function()
    {
        var datefilter = $filter('date');
        $scope.trade.trd_dt = datefilter($scope.trade.trd_dt, 'dd/MM/yyyy');
        $scope.trade.trd_dt = dateconfigservice.FullDateUKtoDateKey($scope.trade.trd_dt);
        $http.get('/Trade/Trade/GetTradeFileDate')
        .success(function (data, status, headers, config) {
            if (data.success == true) {
                $scope.trade.trd_dt = globalvalueservice.getProcessDate();
                $scope.Filedate = data.data;
            }
            
        });
    }
    
    $scope.UpdateInvestorTrade = function (id,client_code) {
        $http.get('/Trade/Trade/CheckInvestor?investor_code=' + client_code)
        .success(function (data) {
            if(data=='Available')
            {
                $http({
                    method: 'POST',
                    url: '/Trade/Trade/UpdateInvestorTrade',
                    data: {id : id,client_code : client_code}
                }).success(function (data) {
                        toastr.success("Investor Edited successfully");
                }).
               error(function (XMLHttpRequest, textStatus, errorThrown) {
                   $scope.trade.trd_dt = globalvalueservice.getProcessDate();
                   toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
               });
            }
            else
            {
                toastr.error('Client Code '+client_code + ' ' + data);
            }
        })
    };

    $scope.ReverseTradeFile = function () {
        if ($scope.TradeFileForm.$valid) {
            $scope.isTradeFileAlreadyExecuted()
            .then($scope.ReverseTradeProcess)
            .then(function () {
                $(".loader").hide();
            });
        }
    };

    $scope.ReverseTradeProcess = function () {
        var deffered = $q.defer();
        $timeout(function () {
            if ($scope.executed == 1) {
                $('.loader').show();
            var inputDate = dateconfigservice.FullDateUKtoDateKey($scope.trade.trd_dt);
            $http.get('/Trade/Trade/ReverseTradeFile?date=' + inputDate +'&stock_exchange_id='+$scope.trade.stock_exchange_id)
            .success(function (data) {
                toastr.success(data);
                
                deffered.resolve();
            }).
            error(function (XMLHttpRequest, textStatus, errorThrown) {
                $scope.trade.trd_dt = globalvalueservice.getProcessDate();
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
                deffered.resolve();
            });
        }
        else {
            toastr.error('You cannot reverse a trade without executing!!!');
            deffered.resolve();
        }
        }, 0);
        return deffered.promise;
    };
});