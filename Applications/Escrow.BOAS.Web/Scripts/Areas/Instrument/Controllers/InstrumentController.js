angular.module('myApp').controller('InstrumentController', function ($scope, $window, $http, $location, $routeParams, $filter, dropdownservice, dateconfigservice, Upload, isundefinedornullservice, globalvalueservice) {
    $scope.instrument = {};
    var ifIsinAvailable;
    var ifSecurityAvailable;
    $scope.saveNewInstrument = function () {
        var instrument_name = $scope.instrument.instrument_name;
        var sector_id = $scope.instrument.sector_id;
        var instrument_type_id = $scope.instrument.instument_type_id;
        var security_code = $scope.instrument.security_code;
        var depository_company_id = $scope.instrument.depository_company_id;
        var face_value = $scope.instrument.face_value;
        var lot = $scope.instrument.lot;
        var group_id = $scope.instrument.group_id
        var isin = '';
        isin = $scope.instrument.isin;

        //$scope.premiumRadio = '';
        var doesIsinExist;
        if (angular.isUndefined($scope.instrument.is_marginable)) {
            $scope.instrument.is_marginable = 0;
        }
        if (angular.isUndefined($scope.instrument.is_foreign)) {
            $scope.instrument.is_foreign = 0;
        }


        if (ifIsinAvailable == 0) {
            toastr.error('Isin is not valid');
        }

        else if (ifSecurityAvailable == 0) {
            toastr.error('Security Code is not Available');
        }

        else {

            if ($scope.newInstrumentForm.$valid) {
                if ($scope.premiumRadio != 'Premium') {
                    $scope.instrument.premium = 0;
                }
                if ($scope.premiumRadio != 'Discount') {
                    $scope.instrument.discount = 0;
                }
                $http({
                    method: 'POST',
                    url: '/Instrument/Instrument/AddNewInstrument',
                    data: $scope.instrument
                }).success(function (data) {
                    if (data.Success) {
                        toastr.success("Submitted Successfully");
                        $location.path('/InstrumentList');

                    }
                    else {
                        toastr.error(data.errorMessage);
                    }
                });
            }
        }
    };

    $scope.LoadAllDropDown = function () {
        $scope.SectorList = null;
        $http.get('/Instrument/Instrument/GetddlSector/')
        .success(function (data) {
            $scope.SectorList = data;
        }).
      error(function (XMLHttpRequest, textStatus, errorThrown) {
          toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
      })
        var ddl_sector_id = $scope.ddl_sector_id;

        if (ddl_sector_id == null || ddl_sector_id.toString().trim() == "" || ddl_sector_id.toString().trim() == "undefined") {
            //ddl_sector_id = 0;
        }

        $scope.instrument.sector_id = ddl_sector_id;
        //};


        //load Instrument Type List for Dropdown
        //var loadInstrumentTypes = function () {
        $scope.TypeList = null;
        $http.get('/Instrument/Instrument/GetddlType/')
        .success(function (data) {
            $scope.TypeList = data;
        }).
      error(function (XMLHttpRequest, textStatus, errorThrown) {
          toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
      })
        //};

        // load Depository Company for DropDown
        //var loadDepositoryCompanies = function () {
        $scope.CompanyList = null;
        $http.get('/Instrument/Instrument/GetddlDepositoryCompany/')
        .success(function (data) {
            $scope.CompanyList = data;
        }).
      error(function (XMLHttpRequest, textStatus, errorThrown) {
          toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
      })
        //};

        // Load CompanyGroup for dropdown

        //var loadGroups = function () {
        $scope.GroupList = null;
        $http.get('/Instrument/Instrument/GetddlGroups/')
        .success(function (data) {
            $scope.GroupList = data;
        }).
      error(function (XMLHttpRequest, textStatus, errorThrown) {
          toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
      })
        //};

        //var loadStatus = function () {
        $scope.StatusList = null;
        $http.get('/Instrument/Instrument/GetStatus/')
        .success(function (data) {
            $scope.StatusList = data;
        }).
      error(function (XMLHttpRequest, textStatus, errorThrown) {
          toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
      })
        //};

    };

    $scope.loadInstrumentList = function () {
        $scope.rowCollection = [];
        $http.get('/Instrument/Instrument/GetAllInstrument/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.instruments;
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


    //load instrument in edit mode

    $scope.loadInstrumentById = function () {
        //$scope.LoadAllDropDown();
        //$scope.instrument = {};
        $http.get('/Instrument/Instrument/GetInstrumentById/' + $routeParams.id)
        .success(function (data) {
            if (data.success) {
                $scope.editInstrument = data.instrument;
                if ($scope.editInstrument.premium != 0) {
                    $scope.premiumRadio = 'Premium';
                }
                if ($scope.editInstrument.discount != 0) {
                    $scope.premiumRadio = 'Discount';
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

    $scope.loadNewInsrument = function () {
        $scope.instrument = {};
    }

    $scope.updateInstrument = function () {
        //if ($scope.instrumentEditform.$valid) {
        if ($scope.premiumRadio != 'Premium') {
            $scope.editInstrument.premium = 0;
        }
        if ($scope.premiumRadio != 'Discount') {
            $scope.editInstrument.discount = 0;
        }
        if (ifIsinAvailable == 0) {
            toastr.error('Isin is not valid');
        }
        else {
            $http({
                method: 'POST',
                url: '/Instrument/Instrument/UpdateInstrument',
                data: $scope.editInstrument
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/InstrumentList');
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
    $scope.loadEditInsrument = function () {
        $scope.loadInstrumentById();
    };
    $scope.CheckIsin = function (isin) {
        if ($scope.instrument.isin.length != 12 && $scope.instrument.isin.length != 0) {
            ifIsinAvailable = 0;
            toastr.error('Isin Must be 12 digits');
        }
        else if ($scope.instrument.isin.length == 12) {
            $http.get('/Instrument/Instrument/CheckIsin?isin=' + isin)
            .success(function (data) {
                if (data == 'NoAvailable') {
                    ifIsinAvailable = 0;
                    toastr.error('This ISIN Already Registered');
                }
                else {
                    ifIsinAvailable = 1;
                    toastr.success('ISIN is available');
                }
            })

        }
    };

    $scope.CheckSecurityName = function (SecurityCode) {
        $http.get('/Instrument/Instrument/CheckSecurityCode?SecurityCode=' + SecurityCode)
            .success(function (data) {
                if (data == 'NoAvailable') {
                    ifSecurityAvailable = 0;
                    toastr.error('This Security Code Already Registered');
                }
                else {
                    ifSecurityAvailable = 1;
                    toastr.success('Security Code is Available');
                }
            })

    };


    $scope.CheckIsinForEdit = function (security_code, isin) {
        if ($scope.editInstrument.isin.length != 12 && $scope.editInstrument.isin.length != 0) {
            ifIsinAvailable = 0;
            toastr.error('Isin Must be 12 digits');
        }
        else if ($scope.editInstrument.isin.length == 12) {
            $http.get('/Instrument/Instrument/CheckIsinForEdit?security_code=' + security_code + '&isin=' + isin)
            .success(function (data) {
                if (data == 'NoAvailable') {
                    ifIsinAvailable = 0;
                    toastr.error('This ISIN Already Registered');
                }
                else {
                    ifIsinAvailable = 1;
                    toastr.success('ISIN is available');
                }
            })

        }
    };


});