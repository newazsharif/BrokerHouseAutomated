//CREATED BY: Rifad
//Date: 17-5-2017
//
//
angular.module('myApp').controller('OmnibusController', function ($scope, $window, $http, $location, $routeParams, $filter, Upload, dateconfigservice, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("--- Omnibus Information");
    $scope.image = '../Images/images.png';
    $scope.open = function ($event, opened) {
        $event.preventDefault();
        $event.stopPropagation();
        $scope[opened] = true;
    };

    $scope.loadOmnibusList = function () {
        $scope.rowCollection = [];
        $http.get('/InvestorManagement/Omnibus/GetAllOmnibus/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.data;
                  $scope.displayedCollection = [].concat($scope.rowCollection);
              }
              else {
                  toastr.error(data.errorMessage);
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    }
    $scope.DeleteOmnibus = function (index) {
        $scope.OmnibusInformation = $scope.displayedCollection[index];
        $http.post('/InvestorManagement/Omnibus/DeleteOmnibus/', $scope.OmnibusInformation
           ).
                success(function (data) {
                    if (data.success) {
                        toastr.success("Delete Successfully");
                        $scope.loadOmnibusList();
                    }
                    else {
                        toastr.error(data.errorMessage);
                    }
                }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    }

    $scope.GetActiveStatus = function () {
        $http.get('/InvestorManagement/Omnibus/GetActiveStatus').success(function (data) {

            $scope.StatusList = data;

        }).error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    }

    $scope.LoadOmnibusById = function () {
        $scope.id = $routeParams.id;
        $http.get('/InvestorManagement/Omnibus/GetOmnibusById/' + $routeParams.id)
            .success(function (data) {
                if (data.success) {
                    $scope.OmnibusInformation = data.data;
               //     $scope.GetActiveStatus();
                } else {
                    toastr.error(data.errorMessage);

                }
            }).error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');

            })
    }
    $scope.updateOmnibus = function () {
        if ($scope.updateOmnibusForm.$valid) {
            $http.post('/InvestorManagement/Omnibus/UpdateOmnibus/', $scope.OmnibusInformation)
           .success(function (data) {
               if (data.success) {
                   toastr.success("Update Successfully");
               } else {
                   toastr.error(data.errorMessage);
               }
           }).error(function (XMLHttpRequest, textStatus, errorThrown) {
               toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!!!!!');
           })
        }
    }
    $scope.addNewOmnibus = function () {
        if ($scope.newOmnibusForm.$valid) {
            $http.post('/InvestorManagement/Omnibus/NewOmnibus', $scope.OmnibusInformation)
                .success(function (data) {
                    if (data.success) {
                        toastr.success(data.data);
                    } else {
                        toastr.error(data.errorMessage);
                    }
                }).error(function (XMLHttpRequest, textStatus, errorThrown) {
                    toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'ERROR!!!!!!!!!!');
                })
        }
    }
    $scope.loadDropDown = function () {
        $scope.GetActiveStatus();
    }



});