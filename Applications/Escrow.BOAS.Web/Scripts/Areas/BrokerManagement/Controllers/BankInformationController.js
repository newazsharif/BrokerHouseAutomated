//CREATED BY: Rifad
//Date: 6-5-2017
//
//
angular.module('myApp').controller('BankInformationController', function ($scope, $window, $http, $location, $routeParams, $filter, Upload, dateconfigservice, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("--- Bank Information");

    $scope.image = '../Images/images.png';

    $scope.open = function ($event, opened) {


        $event.preventDefault();
        $event.stopPropagation();

        $scope[opened] = true;

    };

    $scope.loadBankList = function () {
        $scope.rowCollection = [];
        $http.get('/BrokerManagement/BankInformation/getBankList/').
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
    };

    $scope.refresh = function () {
        $scope.StatusList = "";
        $scope.bankInformation.short_name = "";
        $scope.bankInformation.bank_name = "";
        //  $scope.bankInformation.active_status_id = "";
        $scope.LoadAllDropDown();

    };
    $scope.saveNewBank = function () {

        if ($scope.newBankForm.$valid) {
            $http.post('/BrokerManagement/BankInformation/AddNewBank/', $scope.bankInformation
            ).
                 success(function (data) {
                     if (data.success) {
                         toastr.success("Submitted Successfully");
                         $scope.rowCollection = data.data;
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

    $scope.LoadAllDropDown = function () {
        $scope.ActiveStatus();

        $scope.DistrictName();
    };
    $scope.ActiveStatus = function () {
        $scope.StatusList = null;
        $http.get('/BrokerManagement/BankInformation/GetStatus/')
        .success(function (data) {
            $scope.StatusList = data;
        }).
      error(function (XMLHttpRequest, textStatus, errorThrown) {
          toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
      });
    }

    $scope.loadBankById = function () {
        $scope.bankInformation = {};
        $http.get('/BrokerManagement/BankInformation/GetBankById/' + $routeParams.id).
          success(function (data) {
              if (data.success) {
                  $scope.bankInformation = data.data;
               //   $scope.LoadAllDropDown();
              }
              else {
                  toastr.error(data.errorMessage);
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };


    $scope.updateBank = function (id) {
        if ($scope.newBankForm.$valid) {
            $scope.bankInformation.id = id;
            $http.post('/BrokerManagement/BankInformation/UpdateBank/', $scope.bankInformation
            ).
                 success(function (data) {
                     if (data.success) {
                         toastr.success("Update Successfully");
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

    $scope.DeleteBank = function (index) {

        // $id = 0;
        $scope.bankInformation = $scope.displayedCollection[index];

        $http.post('/BrokerManagement/BankInformation/DeleteBank/', $scope.bankInformation
           ).
                success(function (data) {
                    if (data.success) {
                        toastr.success("Delete Successfully");
                        //$scope.displayedCollection.splice(index, 1);
                        $scope.loadBankList();
                    }
                    else {
                        toastr.error(data.errorMessage);
                    }
                }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };
    $scope.loadBranchList = function () {
        $scope.bank_id = $routeParams.id;
        $scope.bankInformation = {};
        $http.get('/BrokerManagement/BankInformation/GetBranchByBankId/' + $routeParams.id).
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.data;
                  $scope.displayedCollection = [].concat($scope.rowCollection);
                  $scope.loadBankById();
              }
              else {
                  toastr.error(data.errorMessage);
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };
    $scope.loadBranchById = function () {
        $http.get('/BrokerManagement/BankInformation/GetBranchById/' + $routeParams.id)
          .success(function (data) {
              if (data.success) {
                  $scope.branchInformation = data.data;
              }
              else {
                  toastr.error(data.errorMessage);
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.DistrictName = function () {
        $scope.StatusList = null;
        $http.get('/BrokerManagement/BankInformation/DistrictName/')
        .success(function (data) {
            $scope.DistrictList = data;
        }).
      error(function (XMLHttpRequest, textStatus, errorThrown) {
          toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
      })

    };
    $scope.updateBranch = function (id) {
        if ($scope.newBranchForm.$valid) {
            $scope.branchInformation.id = id;
            $http.post('/BrokerManagement/BankInformation/UpdateBranch/', $scope.branchInformation
            ).
                 success(function (data) {
                     if (data.success) {
                         toastr.success("Update Successfully");
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
    $scope.DeleteBranch = function (index) {
        $scope.branchInformation = $scope.displayedCollection[index];

        $http.post('/BrokerManagement/BankInformation/DeleteBranch/', $scope.branchInformation
           ).
                success(function (data) {
                    if (data.success) {
                        toastr.success("Delete Successfully");
                        //$scope.displayedCollection.splice(index, 1);
                        $scope.loadBranchList();
                    }
                    else {
                        toastr.error(data.errorMessage);
                    }
                }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    }


    $scope.KeepBankId = function () {
        $scope.branchInformation = {};
        $scope.branchInformation.bank_id = $routeParams.id;
        $scope.LoadAllDropDown();
    };


    $scope.saveNewBranch = function () {

        if ($scope.newBranchForm.$valid) {
            $http.post('/BrokerManagement/BankInformation/AddNewBranch/', $scope.branchInformation
            ).
                 success(function (data) {
                     if (data.success) {
                         toastr.success("Submitted Successfully");
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
    $scope.refreshBranch = function () {
        branchInformation.branch_name = "";
        branchInformation.address = "";
        branchInformation.email_address = "";
        branchInformation.contact_person = "";
        branchInformation.contact_number = "";
        branchInformation.routing_no = "";
    }


});