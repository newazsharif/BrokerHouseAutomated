angular.module('myApp').controller('ExportExcelForSMSController', function ($scope, $window, $http, $location, $routeParams, $filter, dateconfigservice, isundefinedornullservice, globalvalueservice) {
    $scope.LoadAllDropDown = function () {
        $scope.setExcelExportForSMS();
    }

    $scope.setExcelExportForSMS = function () {
        $http.get('/Service/ExportExcelForSMS/SetExcelExportForSMS')
        .success(function (data) {
            $scope.ExportExcelforSMSPath = data.data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    }

    $scope.ExportExcelFile = function () {
        if ($scope.export_SMS_form.$valid) {

            var oCode = $scope.dtOcede;
            var fileName = $scope.dtFilename;
            $scope.downloadFilename = fileName+".xlsx"
            $http.get('/Service/ExportExcelForSMS/ExportExcelFileForSMS?oCode=' + oCode + '&filename=' + fileName)          
            .success(function (data) {
                if (data.success) {
                    toastr.success('Export Successful');
                    $scope.dtOcede = "";
                    $scope.dtFilename = "";
                }
                else {
                    toastr.error(data.message)
                }


            })
            .error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
        }
    }

});