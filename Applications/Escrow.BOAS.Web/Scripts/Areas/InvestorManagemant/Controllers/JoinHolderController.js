angular.module('myApp')
.controller('JoinHolderController', function ($scope, $window, $http, $location, $routeParams, $filter, dropdownservice,globalvalueservice, dateconfigservice, Upload, isundefinedornullservice) {
    $scope.newJoinHolder = {};
    $scope.customStyle = {};
    $scope.image = '../Images/images.png';
    $scope.signature = '../Images/signature.jpg';
    $scope.editJoinHolder = {};
    var investor_validity;
    $scope.open = function ($event, opened) {
        $event.preventDefault();
        $event.stopPropagation();
        $scope[opened] = true;
    };

    $scope.getAllJoinHolder = function () {
        $scope.rowCollection = [];
        $http.get('InvestorManagement/JoinHolder/GetAllJoinHolder')
        .success(function (data) {
            if (data.success) {
                $scope.rowCollection = data.joinHolders;
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


    $scope.loadJoinHolderById = function () {
        $http.get('/InvestorManagement/JoinHolder/LoadJoinHolderById?client_id=' + $routeParams.id)
        .success(function (data) {
            if (data.success) {
                $scope.editJoinHolder = data.joinHolder;
                if (!isundefinedornullservice.isUndefinedOrNull($scope.editJoinHolder.DOB)) {
                    $scope.editJoinHolder.DOB = dateconfigservice.DateTimeToDate($scope.editJoinHolder.DOB);
                }
                if (data.ImageData != '') {
                    var imgByteCharacters = atob(data.ImageData);
                    var imgByteNumbers = new Array(imgByteCharacters.length);
                    for (var i = 0; i < imgByteCharacters.length; i++) {
                        imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                    }
                    var imgByteArray = new Uint8Array(imgByteNumbers);
                    $scope.picFile = new Blob([imgByteArray], { type: 'image' });
                    $scope.picFileForSave = new File([$scope.picFile],'');
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
        })
        .error(function (data) {
            toastr.error(data.errorMessage);
        })
    }

    $scope.SaveNewJoinHolder = function (file, sigPic) {

        if (investor_validity == 1) {
            $scope.newJoinHolder.Imagestatus = '';
            if ($scope.newJoinHolderForm.$valid) {
                var tempFile = [];
                
                if (angular.isUndefined(sigPic)) {
                    $scope.newJoinHolder.Imagestatus = 'p';
                    tempFile[0] = file;

                }

                if (angular.isUndefined(file)) {
                    tempFile[0] = sigPic;
                    $scope.newJoinHolder.Imagestatus = 's';
                }
                if (angular.isUndefined(sigPic) == false && angular.isUndefined(file) == false) {
                    tempFile[0] = file;
                    tempFile[1] = sigPic;
                }
                if (angular.isUndefined(sigPic) == true && angular.isUndefined(file) == true) {
                    tempFile = [];
                }
               
                    
                    
                
                //if (angular.isUndefined($scope.newJoinHolder.DOB) || $scope.newJoinHolder.DOB == null) {
                //    $scope.newJoinHolder.DOB = null;
                //}
                if (isundefinedornullservice.isUndefinedOrNull($scope.newJoinHolder.DOB))
                {
                    $scope.newJoinHolder.birth_date = null;
                }
                else {
                    var datefilter = $filter('date');
                    $scope.newJoinHolder.birth_date = datefilter($scope.newJoinHolder.DOB, 'dd/MM/yyyy');
                    //$scope.newJoinHolder.birth_date = dateconfigservice.FullDateUKtoDateKey($scope.newJoinHolder.DOB);
                    $scope.newJoinHolder.birth_date = dateconfigservice.UIDateToServerDate($scope.newJoinHolder.birth_date);
                }
                Upload.upload(
                   {
                       url: '/InvestorManagement/JoinHolder/SaveNewJoinHolder',
                       method: 'POST',
                       fields: $scope.newJoinHolder,
                       file: tempFile,
                       async: true
                   })
               .success(function () {
                   toastr.success('Submitted Successfully');
                   $location.path('/JoinHolderList');
               })
                .error(function () {
                    toastr.error('Error occured!!!!');
                });
            }
        }
    };

    $scope.CheckClientCode = function (client_id) {
        $http.get('/InvestorManagement/JoinHolder/getInvestorInfoById?id=' + client_id)
        .success(function (data) {
            if (data.success == true) {
                $scope.customStyle.style = { "color": "green" };
                $scope.InvestorName = data.investor.first_holder_name;
                investor_validity = 1;

            }
            else {
                $scope.customStyle.style = { "color": "red" };
                $scope.InvestorName = data.errorMessage;
                investor_validity = 0;

            }
        })
        .error(function () {
            $scope.customStyle.style = { "color": "red" };
            $scope.InvestorName = 'Investor Code not valid!!!';
            investor_validity = 0;
        })
    };
    $scope.LoadAllDropDown = function () {

        // Added by Shohid 
        // Reason: age validation of new Joint Holder, min age 18 and max age unlimited (heare given 100 years)//

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
        $scope.newJoinHolder.DOB = new Date(yearMin, month, day);

        // end

        $scope.LoadGender();
        $scope.LoadStatus();

        
    };
    $scope.LoadGender = function () {
        $scope.GenderList = null;
        $http.get('/InvestorManagement/JoinHolder/GetddlGender/')
        .success(function (data) {
            $scope.GenderList = data;
        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };
    $scope.LoadStatus = function () {
        $scope.StatusList = null;
        $http.get('/InvestorManagement/JoinHolder/GetddlStatus/')
        .success(function (data) {
            $scope.StatusList = data;

        })
        .error(function (XMLHttpRequest, textStatus, errorThrown) {
            toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
        });
    };
    

    $scope.UpdateJoinHolder = function (file, sigPic) {
        investor_validity = 1;
        if (investor_validity == 1) {
        $scope.editJoinHolder.Imagestatus = '';
        if ($scope.editJoinHolderForm.$valid) {
                var tempFile = [];
                $scope.editJoinHolder.photo = null;
                $scope.editJoinHolder.signature = null;
                if (angular.isUndefined(sigPic)) {
                    $scope.editJoinHolder.Imagestatus = 'p';
                    tempFile[0] = file;

                }

                if (angular.isUndefined(file)) {
                    tempFile[0] = sigPic;
                    $scope.newJoinHolder.Imagestatus = 's';
                }
                if (angular.isUndefined(sigPic) == false && angular.isUndefined(file) == false) {
                    tempFile[0] = file;
                    tempFile[1] = sigPic;
                }
                if (angular.isUndefined(sigPic) == true && angular.isUndefined(file) == true) {
                    tempFile = [];
                }



                if (isundefinedornullservice.isUndefinedOrNull($scope.editJoinHolder.DOB)) {
                    $scope.editJoinHolder.birth_date = null;
                }
                else {
                    var datefilter = $filter('date');
                    $scope.editJoinHolder.birth_date = datefilter($scope.editJoinHolder.DOB, 'dd/MM/yyyy');
                    //$scope.editJoinHolder.birth_date = dateconfigservice.FullDateUKtoDateKey($scope.editJoinHolder.DOB);
                    $scope.editJoinHolder.birth_date = dateconfigservice.UIDateToServerDate($scope.editJoinHolder.birth_date);
                }
                Upload.upload(
                   {
                       url: '/InvestorManagement/JoinHolder/UpdateJoinHolder',
                       method: 'POST',
                       fields: $scope.editJoinHolder,
                       file: tempFile,
                       async: true
                   })
               .success(function () {
                   toastr.success('Submitted Successfully');
                   $location.path('/JoinHolderList');
                   
               })
                .error(function () {
                    toastr.error('Error occured!!!!');
                });
            }
        }
    };
    $scope.LoadNewJoinHolder = function () {
        $scope.newJoinHolder = {};
    };

    $scope.LoadEditJoinHolder = function () {
        $scope.loadJoinHolderById();
    };
});
