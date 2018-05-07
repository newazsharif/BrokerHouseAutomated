angular.module('myApp').controller('UserEmployeeMappingController', function ($scope, $window, $http, $location, $routeParams) {

    $('#pageTitle').text("--- User Employee Mapping");

    $scope.loadUserEmpMapList = function () {
        $scope.rowCollection = [];
        $http.get('/BrokerManagement/UserEmployeeMapping/getUserEmpMapList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.userEmpMapList;
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

    $scope.loadDropdowns = function () {
        $scope.loadUser();
        $scope.loadEmployee();
        $scope.loadActiveStatus();
    };

    $scope.loadUser = function () {
        $scope.userList = null;
        $http.get('/BrokerManagement/UserEmployeeMapping/getUserDdlList/').
          success(function (data) {
              $scope.userList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadEmployee = function () {
        $scope.employeeList = null;
        $http.get('/BrokerManagement/UserEmployeeMapping/getEmployeeDdlList/').
          success(function (data) {
              $scope.employeeList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadActiveStatus = function () {
        $scope.activeStatusList = null;
        $http.get('/BrokerManagement/UserEmployeeMapping/getActiveStatusDdlList/').
          success(function (data) {
              $scope.activeStatusList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.userEmpMap = {};
    $scope.saveUserEmpMap = function () {

        if ($scope.newUserEmpMapForm.$valid) {

            $http({
                method: 'POST',
                url: '/BrokerManagement/UserEmployeeMapping/addUserEmpMap',
                data: $scope.userEmpMap
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/UserEmployeeMappingList');
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

    $scope.loadUserEmpMapAndDdlById = function () {
        $scope.loadUser();
        $scope.loadEmployee();
        $scope.loadActiveStatus();
        $scope.loadUserEmpMapById($routeParams.id);
    };

    $scope.loadUserEmpMapById = function (id) {
        $http.get('/BrokerManagement/UserEmployeeMapping/getUserEmpMapById/' + id).
          success(function (data) {
              if (data.success) {
                  $scope.editUserEmpMap = data.editUserEmpMap;
              }
              else {
                  toastr.error(data.errorMessage);
                  $location.path('/UserEmployeeMappingList');
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
              $location.path('/UserEmployeeMappingList');
          });
    };

    $scope.editUserEmpMapping = function () {
        if ($scope.editUserEmpMapForm.$valid) {

            $http({
                method: 'POST',
                url: '/BrokerManagement/UserEmployeeMapping/updateUserEmpMap',
                data: $scope.editUserEmpMap
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/UserEmployeeMappingList');
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

    $scope.DeleteUserEmployeeMapping = function (row) {
        var isDelete = confirm("Are you sure you want to delete this mapping!");
        if (isDelete == true) {
            $http({
                method: 'POST',
                url: '/BrokerManagement/UserEmployeeMapping/deleteUserEmpMap',
                data: { id: row.id }
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Deleted Successfully");

                    var index = $scope.rowCollection.indexOf(row);
                    if (index !== -1) {
                        $scope.rowCollection.splice(index, 1);
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
    }

    $scope.refresh = function () {
        $scope.userEmpMap = {};
    };
})