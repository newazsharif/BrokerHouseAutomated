angular.module('myApp').
controller('DayProcessController', function ($scope, $window, $http, $location, $routeParams, dropdownservice, dateconfigservice, $filter, globalvalueservice, Upload, $q, $timeout, DayProcessServices) {
    $scope.dayProcess = {};
    $scope.ExecuteDayEnd = function()
    {
        var ProcessdateUK = dateconfigservice.FullDateUKtoDateKey($scope.dayProcess.trd_dt);
        DayProcessServices.ExecuteDayEnd(ProcessdateUK);
    }
    $scope.initialLoad = function()
    {
        $scope.dayProcess.trd_dt = globalvalueservice.getProcessDate();
    }
})
.service('DayProcessServices', function ($http) {
    this.ExecuteDayEnd = function (input) {
        $(".loader").show();
        $http.get('/ProcessManagement/DayProcess/ExecuteDayEnd?process_dt=' + input)
        .success(function (data) {
            if (data == true) {
                toastr.success('Day End Process completed successfully');
                $(".loader").hide();
                $http.get('/Account/ForceLogOff/')
                .success(function () {
                    $http({
                        method: 'POST',
                        url: '/Account/LogOff'
                    })
                })
                
            }
            else {
                toastr.error(data);
                $(".loader").hide();
            }
        }).error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            $(".loader").hide();
        })
    };
})