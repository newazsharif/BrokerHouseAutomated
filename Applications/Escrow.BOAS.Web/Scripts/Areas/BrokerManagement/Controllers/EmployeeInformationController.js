angular.module('myApp').controller('EmployeeInformationController', function ($scope, $window, $http, $location, $routeParams, $filter, Upload, dateconfigservice, globalvalueservice, isundefinedornullservice) {

    $('#pageTitle').text("--- Employee Information");

    $scope.image = '../Images/images.png';

    $scope.open = function ($event, opened) {
        
        
        $event.preventDefault();
        $event.stopPropagation();

        $scope[opened] = true;
       
    };


    $scope.loadEmployeeList = function () {
        $scope.rowCollection = [];
        $http.get('/BrokerManagement/EmployeeInformation/getEmployeeList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.employeeList;
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
        $scope.employeeInformation.joining_date = globalvalueservice.getProcessDate();
        $scope.employeeInformation.release_date = globalvalueservice.getProcessDate();

        $scope.loadGender();
        $scope.loadBranch();
        $scope.loadDesignation();
        $scope.loadDepartment();
        $scope.loadActiveStatus();

        // Added by Shohid 
        // Reason: age validation of new Employee, min age 15 and max age unlimited (heare given 100 years)//
        // Join date and Release date validation also added here...//

        var temp_date = globalvalueservice.getProcessDate();
        var pt = temp_date.split('/');
        var currentDate = new Date(pt[2], pt[1]-1, pt[0]);
        
        var yearMin = currentDate.getFullYear() - 15;
        var yearMax = currentDate.getFullYear() - 100;
        var month = currentDate.getMonth();
        var day = currentDate.getDate();
        $scope.ageMin15 = new Date(yearMin, month, day);
        $scope.today = new Date(yearMin + 15, month, day);
        $scope.ageMax60 = new Date(yearMax, month, day);
        $scope.employeeInformation.dob = new Date(yearMin, month, day);

        var dob_emp = $scope.employeeInformation.dob;
        var year = dob_emp.getFullYear();
        var month = dob_emp.getMonth();
        var day = dob_emp.getDate();

        $scope.min_join_date = new Date(year + 15, month, day);
        var date = new Date(year + 60, month, day);
        if (date <= $scope.today) {
            $scope.max_join_date = date;
        }
        else {
            $scope.max_join_date = $scope.today;
        }

        $scope.min_rel_date = new Date(year + 15, month, day);
        var date = new Date(year + 60, month, day);
        $scope.max_rel_date = date;


        //end of date validation
    };

    $scope.cal_join_date = function()
    {
        var dob_emp = $scope.employeeInformation.dob;
        var year = dob_emp.getFullYear();
        var month = dob_emp.getMonth();
        var day = dob_emp.getDate();

        $scope.min_join_date = new Date(year + 15, month, day);
        var date = new Date(year + 60, month, day);
        if(date <= $scope.today)
        {
            $scope.max_join_date = date;
        }
        else {
            $scope.max_join_date = $scope.today;
        }
    }

    $scope.cal_rel_date = function () {
        var dob_emp = $scope.employeeInformation.joining_date;
        var year = dob_emp.getFullYear();
        var month = dob_emp.getMonth();
        var day = dob_emp.getDate();

        $scope.min_rel_date = $scope.employeeInformation.joining_date;
        var date = new Date(year + 60, month, day);
            $scope.max_rel_date = date;
    }

    $scope.loadGender = function () {
        $scope.genderList = null;
        $http.get('/BrokerManagement/EmployeeInformation/getGenderDdlList/').
          success(function (data) {
              $scope.genderList = data;
          }).
            error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadBranch = function () {
        $scope.branchList = null;
        $http.get('/BrokerManagement/EmployeeInformation/getBranchDdlList/').
          success(function (data) {
              $scope.branchList = data;
              $scope.employeeInformation.branch_id = data[0].value;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadDesignation = function () {
        $scope.designationList = null;
        $http.get('/BrokerManagement/EmployeeInformation/getDesigDdlList/').
          success(function (data) {
              $scope.designationList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadDepartment = function () {
        $scope.departmentList = null;
        $http.get('/BrokerManagement/EmployeeInformation/getDepDdlList/').
          success(function (data) {
              $scope.departmentList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadActiveStatus = function () {
        $scope.activeStatusList = null;
        $http.get('/BrokerManagement/EmployeeInformation/getActiveStatusDdlList/').
          success(function (data) {
              $scope.activeStatusList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.copyNpaste = function () {
        var mailingAddress = $scope.employeeInformation.mailing_address;
        if (!isundefinedornullservice.isUndefinedOrNull(mailingAddress) && mailingAddress.toString().trim() != "") {
            $scope.employeeInformation.permanent_address = mailingAddress.trim();
        }
    };

    $scope.copyNpasteForEdit = function () {
        var mailingAddress = $scope.editEmployeeInformation.mailing_address;
        if (!isundefinedornullservice.isUndefinedOrNull(mailingAddress) && mailingAddress.toString().trim() != "") {
            $scope.editEmployeeInformation.permanent_address = mailingAddress.trim();
        }
    };

    $scope.employeeInformation = {};
    $scope.saveNewEmployee = function (picFile) {

        if ($scope.newEmpForm.$valid) {

            var datefilter = $filter('date');

            if (!isundefinedornullservice.isUndefinedOrNull($scope.employeeInformation.dob) && $scope.employeeInformation.dob.toString().trim() != "") {
                var birthDate = datefilter($scope.employeeInformation.dob, 'dd/MM/yyyy');
                $scope.employeeInformation.birth_date = dateconfigservice.UIDateToServerDate(birthDate);
            }

            var joiningDate = datefilter($scope.employeeInformation.joining_date, 'dd/MM/yyyy');

            $scope.employeeInformation.joining_dt = dateconfigservice.FullDateUKtoDateKey(joiningDate);

            var releaseDate = $scope.employeeInformation.release_date;

            if (!isundefinedornullservice.isUndefinedOrNull(releaseDate) && releaseDate.toString().trim() != "") {
                releaseDate = datefilter($scope.employeeInformation.release_date, 'dd/MM/yyyy');
                $scope.employeeInformation.release_dt = dateconfigservice.FullDateUKtoDateKey(releaseDate);
            }

            Upload.upload({
                method: 'POST',
                url: '/BrokerManagement/EmployeeInformation/addEmployeeInformation',
                fields: $scope.employeeInformation,
                file: picFile,
                async: true
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/EmployeeInformation');

                }
                else {
                    toastr.error(data.errorMessage);
                }
            }).error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
        }
    }

    $scope.loadEmployeeAndDdlById = function () {
        $scope.loadGender();
        $scope.loadBranch();
        $scope.loadDesignation();
        $scope.loadDepartment();
        $scope.loadActiveStatus();
        $scope.loadEmployeeById($routeParams.id);
    };

    $scope.loadEmployeeById = function (id) {
        $http.get('/BrokerManagement/EmployeeInformation/getEmployeeById/' + id).
          success(function (data) {
              if (data.success) {
                  $scope.editEmployeeInformation = data.editEmployeeInformation;
                  if (!isundefinedornullservice.isUndefinedOrNull($scope.editEmployeeInformation.dob) && $scope.editEmployeeInformation.dob.toString().trim() != "") {
                      $scope.editEmployeeInformation.dob = dateconfigservice.DateTimeToDate($scope.editEmployeeInformation.dob);
                  }

                  if (data.ImageData != '') {
                      var imgByteCharacters = atob(data.ImageData);
                      var imgByteNumbers = new Array(imgByteCharacters.length);
                      for (var i = 0; i < imgByteCharacters.length; i++) {
                          imgByteNumbers[i] = imgByteCharacters.charCodeAt(i);
                      }
                      var imgByteArray = new Uint8Array(imgByteNumbers);
                      $scope.picFile = new Blob([imgByteArray], { type: 'image' });
                  }
              }
              else {
                  toastr.error(data.errorMessage);
                  $location.path('/EmployeeInformation');
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
              $location.path('/EmployeeInformation');
          });
    };

    $scope.editEmployee = function (picFile) {
        if ($scope.editEmpForm.$valid) {
            var datefilter = $filter('date');

            if (!isundefinedornullservice.isUndefinedOrNull($scope.editEmployeeInformation.dob) && $scope.editEmployeeInformation.dob.toString().trim() != "") {
                var birthDate = datefilter($scope.editEmployeeInformation.dob, 'dd/MM/yyyy');
                $scope.editEmployeeInformation.birth_date = dateconfigservice.UIDateToServerDate(birthDate);
            }

            var joiningDate = datefilter($scope.editEmployeeInformation.joining_date, 'dd/MM/yyyy');

            $scope.editEmployeeInformation.joining_dt = dateconfigservice.FullDateUKtoDateKey(joiningDate);

            var releaseDate = $scope.editEmployeeInformation.release_date;

            if (!isundefinedornullservice.isUndefinedOrNull(releaseDate) && releaseDate.toString().trim() != "") {
                releaseDate = datefilter($scope.editEmployeeInformation.release_date, 'dd/MM/yyyy');
                $scope.editEmployeeInformation.release_dt = dateconfigservice.FullDateUKtoDateKey(releaseDate);
            }

            $scope.editEmployeeInformation.photo = null;

            Upload.upload({
                method: 'POST',
                url: '/BrokerManagement/EmployeeInformation/updateEmployeeInformation',
                fields: $scope.editEmployeeInformation,
                file: picFile,
                async: true
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/EmployeeInformation');

                }
                else {
                    toastr.error(data.errorMessage);
                }
            }).error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
        }
    };

    $scope.DeleteEmployee = function (row) {
        var isDelete = confirm("Are you sure you want to delete employee!");
        if (isDelete == true) {
            $http({
                method: 'POST',
                url: '/BrokerManagement/EmployeeInformation/deleteEmployee',
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
        $scope.employeeInformation = {};
    };
})