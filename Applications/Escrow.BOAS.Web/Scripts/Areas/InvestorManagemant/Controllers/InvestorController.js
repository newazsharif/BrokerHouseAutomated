angular.module('myApp')
.controller('InvestorController', function ($scope, $window, $http, $location, $routeParams, $filter, dropdownservice, dateconfigservice, Upload, isundefinedornullservice, globalvalueservice) {
    $scope.image = '../Images/images.png';
    $scope.signature = '../Images/signature.jpg';
    $scope.open = function ($event, opened) {
        $event.preventDefault();
        $event.stopPropagation();

        $scope[opened] = true;

    };
    var ifBoAvailable;
    var ifInvestorAvalilable;
    $scope.investor = {};
    $scope.getAllInvestor = function () {
        $scope.rowCollection = [];
        $http.get('InvestorManagement/Investor/GetAllInvestors/')
        .success(function (data) {
            if (data.success) {
                $scope.rowCollection = data.investors;
                $scope.displayedCollection = [].concat($scope.rowCollection);
            }
            else {
                toastr.error(data.errorMessage);
            }
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };

    $scope.AddNewInvestor = function (file, sigPic) {
        if (ifBoAvailable == 0) {
            toastr.error('Bo Code error!!!');
        }

        else if (ifInvestorAvalilable == 0) {
            toastr.error('Investor not available!!!');
        }
        else {
            $scope.investor.Imagestatus = '';
            var tempFile = [];
            if ($scope.newInvestorForm.$valid) {
                if (angular.isUndefined(sigPic)) {
                    $scope.investor.Imagestatus = 'p';
                    tempFile[0] = file;

                }

                if (angular.isUndefined(file)) {
                    tempFile[0] = sigPic;
                    $scope.investor.Imagestatus = 's';
                }
                if (angular.isUndefined(sigPic) == false && angular.isUndefined(file) == false) {
                    tempFile[0] = file;
                    tempFile[1] = sigPic;
                }
                if (angular.isUndefined(sigPic) && angular.isUndefined(file)) {
                    tempFile = [];
                }
                var datefilter = $filter('date');
                $scope.investor.birth_date = datefilter($scope.investor.birth_date, 'dd/MM/yyyy');
                //$scope.investor.birth_date = dateconfigservice.FullDateUKtoDateKey($scope.investor.birth_date);
                $scope.investor.birth_date = dateconfigservice.UIDateToServerDate($scope.investor.birth_date);

                if (!angular.isUndefined($scope.investor.opening_date)) {
                    $scope.investor.opening_date = datefilter($scope.investor.opening_date, 'dd/MM/yyyy');
                    $scope.investor.opening_date = dateconfigservice.FullDateUKtoDateKey($scope.investor.opening_date);
                }
                if (!angular.isUndefined($scope.investor.passport_issue_date)) {
                    $scope.investor.passport_issue_date = datefilter($scope.investor.passport_issue_date, 'dd/MM/yyyy');
                    //$scope.investor.passport_issue_date = dateconfigservice.FullDateUKtoDateKey($scope.investor.passport_issue_date);
                    $scope.investor.passport_issue_date = dateconfigservice.UIDateToServerDate($scope.investor.passport_issue_date);
                }
                if (!angular.isUndefined($scope.investor.passport_valid_to_date)) {
                    $scope.investor.passport_valid_to_date = datefilter($scope.investor.passport_valid_to_date, 'dd/MM/yyyy');
                    //$scope.investor.passport_valid_to_date = dateconfigservice.FullDateUKtoDateKey($scope.investor.passport_valid_to_date);
                    $scope.investor.passport_valid_to_date = dateconfigservice.UIDateToServerDate($scope.investor.passport_valid_to_date);
                }

                Upload.upload({
                    method: 'POST',
                    url: '/InvestorManagement/Investor/SaveNewInvestor',
                    fields: $scope.investor,
                    file: tempFile,
                    async: true
                }).success(function (data) {
                    if (data.success) {
                        toastr.success("Submitted Successfully");
                        $location.path('/InvestorList');

                    }
                    else {
                        toastr.error(data.errorMessage);
                    }
                });
            }
        }

    };

    $scope.editInvestor = {};
    $scope.loadInvestorById = function () {
        $http.get('/InvestorManagement/Investor/GetInvestorById/' + $routeParams.id)
            .success(function (data) {
                if (data.success) {
                    $scope.editInvestor = data.investor;

                    debugger;
                    var datefilter = $filter('date');
                    if (!isundefinedornullservice.isUndefinedOrNull($scope.editInvestor.DOB)) {
                        $scope.editInvestor.birth_date = dateconfigservice.DateTimeToDate($scope.editInvestor.DOB);
                    }
                    if (!angular.isUndefined($scope.editInvestor.Passport_issue_date)) {
                        if ($scope.editInvestor.Passport_issue_date != null) {
                            $scope.editInvestor.passport_issue_date = dateconfigservice.DateTimeToDate($scope.editInvestor.Passport_issue_date);
                        }
                    }
                    if (!angular.isUndefined($scope.editInvestor.Passport_valid_to_date)) {
                        if ($scope.editInvestor.Passport_valid_to_date != null) {
                            $scope.editInvestor.passport_valid_to_date = dateconfigservice.DateTimeToDate($scope.editInvestor.Passport_valid_to_date);
                        }
                    }

                    if (!angular.isUndefined($scope.editInvestor.opening_date)) {
                        $scope.editInvestor.opening_date = $scope.editInvestor.Opening_date;
                    }
                    if (data.ImageData != '') {
                        var imgByteCharacters = atob(data.ImageData);
                        var imgByteNumbers = new Array(imgByteCharacters.length);
                        for (var i = 0; i < imgByteCharacters.length; i++) {
                            imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                        }
                        var imgByteArray = new Uint8Array(imgByteNumbers);
                        $scope.picFile = new Blob([imgByteArray], { type: 'image' });
                        $scope.picFileForSave = new File([$scope.picFile], '');
                    }

                    if (data.SignatureData != '') {
                        var sigByteCharacters = atob(data.SignatureData);
                        var sigByteNumbers = new Array(sigByteCharacters.length);
                        for (var i = 0; i < sigByteCharacters.length; i++) {
                            sigByteNumbers[i] = sigByteCharacters.charCodeAt(i);
                        }
                        var sigByteArray = new Uint8Array(sigByteNumbers);
                        $scope.sigFile = new Blob([sigByteArray], { type: 'image' });
                        $scope.sigFileForSave = new File([$scope.sigFile], '');
                    }
                }
                else {
                    toastr.error(data.errorMessage);
                }
            }).
            error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
    };

    $scope.updateInvestor = function (file, sigPic) {

        if (ifBoAvailable == 0) {
            toastr.error('BO Code Error');
        }

        else if ($scope.editInvestorForm.$valid) {
            //var datefilter = $filter('date');
            //$scope.editInvestor.DOB = datefilter($scope.editInvestor.DOB, 'dd/MM/yyyy');
            var datefilter = $filter('date');
            //$scope.editInvestor.birth_date = datefilter($scope.editInvestor.birth_date, 'dd/MM/yyyy');
            //$scope.editInvestor.birth_date = dateconfigservice.FullDateUKtoDateKey($scope.editInvestor.birth_date);
            if (!angular.isUndefined($scope.editInvestor.birth_date)) {
                if ($scope.editInvestor.birth_date != null) {
                    $scope.editInvestor.birth_date = datefilter($scope.editInvestor.birth_date, 'dd/MM/yyyy');
                    $scope.editInvestor.birth_date = dateconfigservice.UIDateToServerDate($scope.editInvestor.birth_date);
                }
            }

            if (!angular.isUndefined($scope.editInvestor.opening_date)) {
                if ($scope.editInvestor.opening_date != null) {
                    $scope.editInvestor.opening_date = datefilter($scope.editInvestor.opening_date, 'dd/MM/yyyy');
                    $scope.editInvestor.opening_date = dateconfigservice.FullDateUKtoDateKey($scope.editInvestor.opening_date);
                }
            }
            if (!angular.isUndefined($scope.editInvestor.passport_issue_date)) {
                if ($scope.editInvestor.passport_issue_date != null) {
                    $scope.editInvestor.passport_issue_date = datefilter($scope.editInvestor.passport_issue_date, 'dd/MM/yyyy');
                    $scope.editInvestor.passport_issue_date = dateconfigservice.UIDateToServerDate($scope.editInvestor.passport_issue_date);

                }
            }
            if (!angular.isUndefined($scope.editInvestor.passport_valid_to_date)) {
                if ($scope.editInvestor.passport_valid_to_date != null) {
                    $scope.editInvestor.passport_valid_to_date = datefilter($scope.editInvestor.passport_valid_to_date, 'dd/MM/yyyy');
                    $scope.editInvestor.passport_valid_to_date = dateconfigservice.UIDateToServerDate($scope.editInvestor.passport_valid_to_date);
                }
            }
            $scope.editInvestor.Imagestatus = '';
            var tempFile = [];
            if (angular.isUndefined(sigPic)) {
                $scope.editInvestor.Imagestatus = 'p';
                tempFile[0] = file;

            }

            if (angular.isUndefined(file)) {
                tempFile[0] = sigPic;
                $scope.editInvestor.Imagestatus = 's';

            }
            if (angular.isUndefined(sigPic) == false && angular.isUndefined(file) == false) {
                tempFile[0] = file;
                tempFile[1] = sigPic;
            }
            if (angular.isUndefined(sigPic) == true && angular.isUndefined(file) == true) {
                tempFile = [];
            }
            Upload.upload({
                method: 'POST',
                url: '/InvestorManagement/Investor/UpdateInvestor',
                fields: $scope.editInvestor,
                file: tempFile,
                async: true
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/InvestorList');
                }
                else {
                    toastr.error(data.errorMessage);
                }
            }).error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
        }

    };


    $scope.LoadAllDropDown = function () {

        $scope.loadBoRef();
        $scope.LoadGender();
        $scope.loadOpetarionType();
        $scope.loadAccType();
        $scope.LoadBank();
        $scope.LoadBranch();
        $scope.LoadTrader();
        $scope.loadTradeType();
        $scope.LoadIpoType();
        $scope.LoadStatus();
        $scope.loadDistrict();
        $scope.loadThana();
        $scope.LoadIntroducer();
        $scope.LoadInvestorSubAcc();
        $scope.LoadOmnibus();

        // Added by Shohid 
        // Reason: age validation of new Investor, min age 18 and max age unlimited (heare given 100 years)//

        var temp_date = globalvalueservice.getProcessDate();
        var pt = temp_date.split('/');
        var currentDate = new Date(pt[2], pt[1] - 1, pt[0]);

        var yearMin = currentDate.getFullYear() - 18;
        var yearMax = currentDate.getFullYear() - 100;
        var month = currentDate.getMonth();
        var day = currentDate.getDate();

        $scope.ageMin18 = new Date(yearMin, month, day);
        $scope.today = new Date(yearMin + 18, month, day);
        $scope.ageMax100 = new Date(yearMax, month, day);
        $scope.investor.birth_date = new Date(yearMin, month, day);


    };

    $scope.LoadDropDownForEdit = function () {
        $scope.loadBoRef();
        $scope.LoadGender();
        $scope.loadOpetarionType();
        $scope.loadAccType();
        $scope.LoadBank();
        $scope.LoadBranch();
        $scope.LoadTrader();
        $scope.loadTradeType();
        $scope.LoadIpoType();
        $scope.LoadStatus();
        $scope.LoadBankBranchEdit();
        $scope.loadDistrict();
        $scope.loadThana();
        $scope.LoadIntroducer();
        $scope.LoadInvestorSubAcc();
        $scope.LoadOmnibus();

    }

    $scope.loadDistrict = function () {
        $scope.DistrictList = null;
        $http.get('/InvestorManagement/Investor/GetddlDistrict/')
        .success(function (data) {
            $scope.DistrictList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };

    $scope.loadThana = function () {
        $scope.ThanaList = null;
        $http.get('/InvestorManagement/Investor/GetddlThana/')
        .success(function (data) {
            $scope.ThanaList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };
    $scope.loadBoRef = function () {
        $scope.BoRefList = null;
        $http.get('/InvestorManagement/Investor/GetddlBORef/')
        .success(function (data) {
            $scope.BoRefList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };

    $scope.LoadGender = function () {
        $scope.GenderList = null;
        $http.get('/InvestorManagement/Investor/GetddlGender/')
        .success(function (data) {
            $scope.GenderList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };

    $scope.loadOpetarionType = function () {
        $scope.OpetarionTypeList = null;
        $http.get('/InvestorManagement/Investor/GetddlOpType/')
        .success(function (data) {
            $scope.OpetarionTypeList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };

    $scope.loadAccType = function () {
        $scope.AccTypeList = null;
        $http.get('/InvestorManagement/Investor/GetddlAcType/')
        .success(function (data) {
            $scope.AccTypeList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };

    $scope.LoadBank = function () {
        $scope.BankList = null;
        $http.get('/InvestorManagement/Investor/GetddlBank/')
        .success(function (data) {
            $scope.BankList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };



    $scope.LoadTrader = function () {
        $scope.TraderList = null;
        $http.get('/InvestorManagement/Investor/GetddlTrader/')
        .success(function (data) {
            $scope.TraderList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };
    $scope.loadTradeType = function () {
        $scope.TraderTypeList = null;
        $http.get('/InvestorManagement/Investor/GetddlTradeType/')
        .success(function (data) {
            $scope.TraderTypeList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };

    $scope.LoadIpoType = function () {
        $scope.IpoTypeList = null;
        $http.get('/InvestorManagement/Investor/GetddlIpoType/')
        .success(function (data) {
            $scope.IpoTypeList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };

    $scope.LoadBankBranchEdit = function () {
        $scope.BranchList = null;
        $http.get('/InvestorManagement/Investor/GetddlBankBranchEdit/')
        .success(function (data) {
            $scope.BankBranchList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };

    $scope.LoadBranch = function () {
        $scope.BranchList = null;
        $http.get('/InvestorManagement/Investor/GetddlBranch/')
        .success(function (data) {
            $scope.BranchList = data;
            $scope.investor.branch_id = data[0].value;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };
    $scope.LoadBankBranch = function (bank_id) {
        $scope.BankBranchList = null;
        if (bank_id != null) {
            $http.get('/InvestorManagement/Investor/GetddlBankBranch?bank_id=' + bank_id)
            .success(function (data) {
                $scope.BankBranchList = data;
            })
            .error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
        }
    };
    $scope.LoadInvestorSubAcc = function () {
        $scope.InvestorSubAccList = null;
        $http.get('/InvestorManagement/Investor/GetddlInvestorSubAcc/')
        .success(function (data) {
            $scope.InvestorSubAccList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    }

    $scope.LoadIntroducer = function () {
        $scope.IntroducerList = null;
        $http.get('/InvestorManagement/Investor/GetddlIntroducer/')
        .success(function (data) {
            $scope.IntroducerList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };
    $scope.LoadOmnibus = function () {
        $scope.OmnibusList = null;
        $http.get('/InvestorManagement/Investor/GetddlOmnibusMaster/')
        .success(function (data) {
            $scope.OmnibusList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };


    $scope.LoadStatus = function () {
        $scope.StatusList = null;
        $http.get('/InvestorManagement/Investor/GetddlStatus/')
        .success(function (data) {
            $scope.StatusList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };

    $scope.SetBoCode = function (bo_ref) {
        $scope.investor.bo_code = dropdownservice.getSelectedText($scope.BoRefList, $scope.investor.bo_refernce_id);
    };

    $scope.CheckBankAcc = function () {
        $http.get('/InvestorManagement/Investor/CheckBankAcc')
        .success(function (data) {
            var BankAccAvailable = data;
        });

    };

    $scope.CheckBo = function (bo_code) {


        if ($scope.investor.bo_code.length != 16 && $scope.investor.bo_code.length != 0) {
            ifBoAvailable = 0;
            toastr.error('Bo Code Must be 16 digits');
        }
        else if (bo_code.length == 16) {
            $http.get('/InvestorManagement/Investor/CheckBo?bo_code=' + bo_code)
            .success(function (data) {
                if (data == 'NoAvailable') {
                    ifBoAvailable = 0;
                    toastr.error('This Bo Already Registered');
                }
                else {
                    ifBoAvailable = 1;
                    toastr.success('BO is available');
                }
            })

        }


    };

    $scope.CheckInvestor = function (investor_code) {
        if (investor_code != null) {
            $http.get('/InvestorManagement/Investor/CheckInvestor?investor_code=' + investor_code)
       .success(function (data) {
           if (data == 'NoAvailable') {
               ifInvestorAvalilable = 0;
               toastr.error('This Investor Already Registered');
           }
           else {
               ifInvestorAvalilable = 1;
               toastr.success('Investor is available');

           }
       });
        }
    };
    $scope.CheckBranch = function (routing_no) {
        if (routing_no != null) {
            $http.get('/InvestorManagement/Investor/CheckBranch?routing_no=' + routing_no)
       .success(function (data) {
           if (data.success) {
               $scope.investor = data.data;
               $scope.LoadBankBranch($scope.investor.bank_id);
           } else {
               $scope.investor.bank_id = null;
               $scope.investor.bank_branch_id = null;
               toastr.error(data.data);
               $scope.investor.routing_no = "";
               $scope.BankBranchList = null;
               $scope.LoadBank();
           }

       });
        }
    };
    $scope.EditCheckBranch = function (routing_no) {
        if (routing_no != null) {
            $http.get('/InvestorManagement/Investor/CheckBranch?routing_no=' + routing_no)
       .success(function (data) {
           if (data.success) {
               $scope.editInvestor = data.data;
               $scope.LoadBankBranch($scope.editInvestor.bank_id);
           } else {
               $scope.editInvestor.bank_id = null;
               $scope.editInvestor.bank_branch_id = null;
               toastr.error(data.data);
               $scope.editInvestor.routing_no = "";
               $scope.BankBranchList = null;
               $scope.LoadBank();
           }

       });
        }
    };
    $scope.LoadRouter = function (bank_branch_id) {
        if (bank_branch_id != null) {
            $http.get('/InvestorManagement/Investor/LoadRouter?bank_branch_id=' + bank_branch_id)
       .success(function (data) {
           $scope.investor.routing_no = data;
          
       });
        }
    };
    $scope.EditLoadRouter = function (bank_branch_id) {
        if (bank_branch_id != null) {
            $http.get('/InvestorManagement/Investor/LoadRouter?bank_branch_id=' + bank_branch_id)
       .success(function (data) {
           $scope.editInvestor.routing_no = data;

       });
        }
    };
    $scope.CheckBoforEdit = function (client_code, bo_code) {


        if ($scope.editInvestor.bo_code.length != 16 && $scope.editInvestor.bo_code.length != 0) {
            ifBoAvailable = 0;
            toastr.error('Bo Code Must be 16 digits');
        }
        else if (bo_code.length == 16) {
            $http.get('/InvestorManagement/Investor/CheckBoForEdit?client_code=' + client_code + '&bo_code=' + bo_code)
            .success(function (data) {
                if (data == 'NoAvailable') {
                    ifBoAvailable = 0;
                    toastr.error('This Bo Already Registered');
                }
                else {
                    ifBoAvailable = 1;
                    toastr.success('BO is available');
                }
            })

        }


    };

    $scope.Reset = function () {
        $scope.investor = {};
    };

    $scope.ResetEditInvestor = function () {
        $scope.loadInvestorById();
    };

});