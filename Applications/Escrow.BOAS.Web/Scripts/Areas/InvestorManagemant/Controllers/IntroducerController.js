//CREATED BY: Rifad
//Date: 13-5-2017
//
//
angular.module('myApp').controller('IntroducerController', function ($scope, $window, $http, $location, $routeParams, $filter, Upload, dateconfigservice, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("--- Introducer Information");
    $scope.image = '../Images/images.png';
    $scope.open = function ($event, opened) {
        $event.preventDefault();
        $event.stopPropagation();
        $scope[opened] = true;
    };

    $scope.loadIntroducerList = function () {
        $scope.rowCollection = [];
        $http.get('/InvestorManagement/Introducer/GetAllIntroducer/').
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
    $scope.DeleteIntroducer = function (index) {
        $scope.introducerInformation = $scope.displayedCollection[index];
        $http.post('/InvestorManagement/Introducer/DeleteIntroducer/', $scope.introducerInformation
           ).
                success(function (data) {
                    if (data.success) {
                        toastr.success("Delete Successfully");
                        $scope.loadIntroducerList();
                    }
                    else {
                        toastr.error(data.errorMessage);
                    }
                }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    }

    //// Controller Code Baki
    $scope.GetIntroducerType = function () {
        $scope.introducerType = [];
        $http.get('/InvestorManagement/Introducer/GetIntroducerType').success(function (data) {
            $scope.IntroducerList = data;

        }).error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    }
    $scope.IntroducerType = function (bo_ref) {
        $scope.investor.bo_code = dropdownservice.getSelectedText($scope.BoRefList, $scope.investor.bo_refernce_id);
    };
    $scope.GetOccupation = function () {
        $scope.occupation = [];
        $http.get('/InvestorManagement/Introducer/GetOccupation').success(function (data) {

            $scope.occupationList = data;

        }).error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    }
    $scope.GetActiveStatus = function () {
        $scope.occupation = [];
        $http.get('/InvestorManagement/Introducer/GetActiveStatus').success(function (data) {

            $scope.statusList = data;

        }).error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    }

    $scope.LoadIntroducerById = function () {
        $scope.id = $routeParams.id;
        $http.get('/InvestorManagement/Introducer/GetIntroducerById/' + $routeParams.id)
            .success(function (data) {
                if (data.success) {
                    $scope.introducerInformation = data.data;
                    $scope.GetIntroducerType();
                    $scope.GetOccupation();
                    $scope.GetActiveStatus();
                } else {
                    toastr.error(data.errorMessage);

                }
            }).error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');

            })
    }
    $scope.updateIntroducer = function () {
        var datefilter = $filter('date');
        var releaseDate = datefilter($scope.introducerInformation.valid_from, 'dd/MM/yyyy');
        $scope.introducerInformation.valid_from = dateconfigservice.FullDateUKtoDateKey(releaseDate);

        releaseDate = datefilter($scope.introducerInformation.valid_to, 'dd/MM/yyyy');

        $scope.introducerInformation.valid_to = dateconfigservice.FullDateUKtoDateKey(releaseDate);
        debugger;

         if ($scope.UpdateIntroducerForm.$valid) {
            $http.post('/InvestorManagement/Introducer/UpdateIntroducer/', $scope.introducerInformation)
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
    $scope.addNewIntroducer = function () {
        if ($scope.newIntroducerForm.$valid) {
            var datefilter = $filter('date');
            var releaseDate = datefilter($scope.introducerInformation.valid_from, 'dd/MM/yyyy');
            $scope.introducerInformation.valid_from = dateconfigservice.FullDateUKtoDateKey(releaseDate);

            releaseDate = datefilter($scope.introducerInformation.valid_to, 'dd/MM/yyyy');

            $scope.introducerInformation.valid_to = dateconfigservice.FullDateUKtoDateKey(releaseDate);
            $http.post('/InvestorManagement/Introducer/NewIntroducer', $scope.introducerInformation)
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
        $scope.GetIntroducerType();
        $scope.GetOccupation();
        $scope.GetActiveStatus();
    }



});