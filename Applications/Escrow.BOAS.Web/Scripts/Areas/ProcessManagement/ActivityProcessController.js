angular.module('myApp').
controller('ActivityProcessController', function ($scope, $window, $http, $location, $routeParams, dropdownservice, dateconfigservice, $filter, globalvalueservice, Upload, $q, $timeout, DayProcessServices) {
    $scope.initialLoad = function()
    {
        $scope.bkProcess = {};
        $http.get('/ProcessManagement/ActivityProcess/InitialLoad/')
        .success(function (data) {
           
            $scope.bkProcess.path = data;
        })
    }

    $scope.ExecuteBackup = function()
    {
        $(".loader").show();
        $http.get('/ProcessManagement/ActivityProcess/ExecuteBackup?name='+$scope.bkProcess.name+'&path='+$scope.bkProcess.path)
        .success(function (data) {
            if (data.success) {
                toastr.success("BackUp successfully done");
                $(".loader").hide();
                }
                else {
                toastr.error(data.errorMessage);
                $(".loader").hide();
                }
            }).
              error(function (XMLHttpRequest, textStatus, errorThrown) {
                  toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
                  $(".loader").hide();
              });
    }
})