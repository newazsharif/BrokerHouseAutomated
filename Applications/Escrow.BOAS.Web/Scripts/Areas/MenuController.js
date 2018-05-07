angular.module('myApp').controller('MenuController', function ($scope, $window, $http, $location, $routeParams) {
    $scope.init = function () {
        $scope.LoadModules();
        $scope.LoadReports();
        $scope.menu_Key = '';
        $scope.report_Key = '';
    };
    $scope.LoadModules = function () {
        $scope.module = null;
        $http.get('/Account/LoadModules')
        .success(function (data) {
            $scope.module = (data.result);
            $scope.mapped_module = $scope.module;
        });
    };

    $scope.LoadReports = function () {
        $scope.report = null;
        $http.get('/Account/LoadReports')
        .success(function (data) {
            $scope.report = (data.result);
            $scope.mapped_report = $scope.report;
        });
    };
    $scope.GetFilteredMenu = function()
    {
        if($scope.menu_Key == '')
        {
            $scope.module = $scope.mapped_module;
        }
        else
        {
            $scope.LoadModuleById();
        }
    }

    $scope.GetFilteredReport = function ()
    {
        if ($scope.report_Key == '')
        {
            $scope.report = $scope.mapped_report;
        }
        else
        {
            $scope.LoadReportById();
        }
    }
    $scope.LoadModuleById = function () {
        //$scope.module = null;
        $http.get('/Account/LoadModuleById?menu_key=' + $scope.menu_Key)
        .success(function (data) {
            $scope.module = (data.result);
        });
    };

    $scope.LoadReportById = function () {
        //$scope.report = null;
        $http.get('/Account/LoadReportById?menu_key=' + $scope.report_Key)
        .success(function (data) {
            $scope.report = (data.result);
        });
    };
    
});