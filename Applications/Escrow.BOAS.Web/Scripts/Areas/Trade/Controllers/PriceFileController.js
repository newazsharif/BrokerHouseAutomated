angular.module('myApp').
controller('PriceFileController', function ($scope, $window, $http, $location, $routeParams, dropdownservice, dateconfigservice, $filter, globalvalueservice,Upload) {

    $scope.initialLoad = function () {
        //debugger;
        $scope.closePrice = {};
        $scope.Filedate = '';
        $scope.closePrice.trd_dt = globalvalueservice.getProcessDate();
        $scope.loadStockExchange();
        $scope.executed = 0;
        
    };
    $scope.open = function ($event, opened) {
        $event.preventDefault();
        $event.stopPropagation();

        $scope[opened] = true;
    };
    $scope.UploadPriceFile = function (xmlFile) {
        
        if ($('#FileUpload').val().substr($('#FileUpload').val().length - 4) != '.xml') {
            toastr.warning('Please select xml file');
        }
        
        else
        {
            //$(".loader").show();
            //$http.get('/Trade/Trade/UploadPriceFile?link=' + $('#FileUpload').val())
            //.success(function (data) {
            //    $scope.Filedate = data.data;
            //    $(".loader").hide();
            //    $scope.isFileAlreadyExecuted();
            // });

            $(".loader").show();
            var tempFile = [];
            tempFile[0] = xmlFile;
            Upload.upload(
                   {
                       url: '/Trade/Trade/UploadPriceFile',
                       method: 'POST',
                       file: tempFile,
                       async: true
                   }).success(function(data)
                   {
                       if (data.data == 'failed') {
                           toastr.error(data.errorMessage);
                       }
                       else
                       {
                           $scope.Filedate = data.data;
                           $(".loader").hide();
                           toastr.success('Uploaded Successfully!!!');
                           $scope.isFileAlreadyExecuted();
                       }
                   })
        }
    };

    $scope.loadStockExchange = function()
    {
     
        //debugger;
        $http.get('/Trade/Trade/GetddlStockExchange')
        .success(function (data) {
            $scope.StockList = data.data;
            debugger;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    }

    $scope.ExecuteClosePrice = function()
    {
        
        if ($scope.PriceFileForm.$valid) {
            $scope.isFileAlreadyExecuted();
            var datefilter = $filter('date');
            $scope.closePrice.trd_dt = datefilter($scope.closePrice.trd_dt, 'dd/MM/yyyy');
            $scope.closePrice.trd_dt = dateconfigservice.FullDateUKtoDateKey($scope.closePrice.trd_dt);
            if ($('#FileUpload').val() == '') {
                toastr.error('Upload file first!!!');
                $scope.closePrice.trd_dt = globalvalueservice.getProcessDate();
            }

            else if ($('#FileUpload').val().substr($('#FileUpload').val().length - 4) != '.xml') {
                toastr.error('Upload xml and try again!!!');
                $scope.closePrice.trd_dt = globalvalueservice.getProcessDate();
            }
            else if($scope.closePrice.trd_dt != $scope.Filedate)
            {
                toastr.error('File date and process date are not same!!!');
                $scope.closePrice.trd_dt = globalvalueservice.getProcessDate();
            }
            else if($scope.executed==1)
            {
                toastr.error('This file Already been Executed!!!');
                $scope.closePrice.trd_dt = globalvalueservice.getProcessDate();
            }
            else {
                
                $scope.closePrice.trd_dt = globalvalueservice.getProcessDate();
                $(".loader").show();
                $http({
                    method: 'POST',
                    url: '/Trade/Trade/ExecuteClosePrice',
                    data: $scope.closePrice
                }).success(function (data) {
                    if (data.success) {
                        $scope.closePrice.trd_dt = globalvalueservice.getProcessDate();
                        toastr.success("Submitted Successfully");
                        $(".loader").hide();

                    }
                    else {
                        $scope.closePrice.trd_dt = globalvalueservice.getProcessDate();
                        toastr.error(data.errorMessage);
                    }
                }).
               error(function (XMLHttpRequest, textStatus, errorThrown) {
                   $scope.closePrice.trd_dt = globalvalueservice.getProcessDate();
                   toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
               });
            }
        }
    }

    $scope.isFileAlreadyExecuted = function () {
        $http.get('/Trade/Trade/isFileAlreadyExecuted?checkId=' + $scope.Filedate)
        .success(function (data) {
            if(data.executed==true)
            {
                 $scope.executed=1;
            }
            else
            {
                $scope.executed = 0;
            }
        });

        

    };
});