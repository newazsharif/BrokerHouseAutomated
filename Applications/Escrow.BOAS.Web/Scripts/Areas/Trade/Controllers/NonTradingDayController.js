angular.module('myApp').
    controller('NonTradingDayController', function ($scope, $window, $http, $location, $routeParams, dropdownservice, dateconfigservice, globalvalueservice, $filter) {
        $scope.non_trading_typeList = '';
        $scope.nonTradingDayMaster = {};
        $scope.rowDetailCollection = {};

        $scope.LoadAllDropdown = function () {
            $scope.LoadNonTradingType();

            var temp_date = globalvalueservice.getProcessDate();
            var pt = temp_date.split('/');
            //$scope.nonTradingDayMaster.frm_dt = new Date(pt[2], pt[1] - 1, pt[0]);
            //$scope.nonTradingDayMaster.to_dt = new Date(pt[2], pt[1] - 1, pt[0]);
            //$scope.nonTradingDayMaster.frm_dt = $scope.nonTradingDayMaster.to_dt;
        };
        $scope.LoadNonTradingType = function () {
            $http.get('/Trade/Trade/GetddlNonTradingDayType')
            .success(function (data) {
                $scope.non_trading_typeList = data;
            })
            .error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
        };
        $scope.open = function ($event, opened) {
            $event.preventDefault();

            $event.stopPropagation();
            $scope[opened] = true;
            //setTimeout(function () {
            //    $scope[opened] = false;
            //}, 10);
        };

        $scope.UploadPartial = function (input) {
            var text = dropdownservice.getSelectedText($scope.non_trading_typeList, input);
            if (angular.uppercase(text) == 'ON DEMAND') {
                $scope.dynamicTemplate = null;
            }
            if (text == 'WEEKLY') {
                $scope.dynamicTemplate = '/Trade/Trade/_WeeklyPartial';
            }
            else if (text == 'YEARLY') {
                $scope.dynamicTemplate = '/Trade/Trade/_YearlyPartial';
            }
        };

        $scope.loadNonTradingDayList = function () {
            $scope.rowCollection = [];
            $http.get('/Trade/Trade/GetAllNonTradingDay/').
              success(function (data) {
                  if (data.success) {
                      $scope.rowCollection = data.nonTradingDays;
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
        // Created by: Rifad
        // Date : 5-3-2017
        // Start
        $scope.DetailNonTradingDayById = function (Id) {
            $scope.rowDetailCollection = [];
            $scope.Id = Id;
            $http.get('/Trade/Trade/GetDetailNonTradingDayById/', {
                params: { Id: $scope.Id }
            }).
              success(function (data) {
                  if (data.success) {
                      $scope.rowDetailCollection = data.nonTradingDayDetails;
                      //s$scope.displayedCollectionDetail = [].concat($scope.rowDetailCollection);
                  }
                  else {
                      toastr.error(data.errorMessage);
                  }
              }).
              error(function (XMLHttpRequest, textStatus, errorThrown) {
                  toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
              });
        }


        $scope.DeleteNonTradingDayById = function (Id, master_id) {
            $scope.Id = Id;
            $scope.master_id = master_id;
            $http.get('/Trade/Trade/DeleteNonTradingDayById/', {
                params: { Id: $scope.Id }
            }).
              success(function (data) {
                  if (data.success) {
                  //    toastr.success(data.message);
                      var index = getIndexOf($scope.rowDetailCollection, $scope.Id, "Id");
                      $scope.rowDetailCollection.splice(index, 1);
                      var len = $scope.rowDetailCollection.length;;
                      if (len < 1) {
                          DeleteNonTradingMasterByMasterId($scope.master_id);
                      } else {
                          toastr.success(data.message);
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

        function DeleteNonTradingMasterByMasterId(master_id) {
            $scope.master_id = master_id;
            $http.get('/Trade/Trade/DeleteNonTradingMasterById/', {
            params:{Id: $scope.master_id}
            }).success(function (data){
                if (data.success) {
                    //    toastr.success(data.message);
                    var index = getIndexOf($scope.displayedCollection, $scope.master_id, "Id");
                    $scope.displayedCollection.splice(index, 1);
                    toastr.success(data.message);
                }
                else {
                    toastr.error(data.errorMessage);
                }
            });
        }


        function getIndexOf(arr, val, prop) {
            var l = arr.length,
              k = 0;
            for (k = 0; k < l; k = k + 1) {
                if (arr[k][prop] === val) {
                    return k;
                }
            }
            return false;
        }
        //end
        /////////////////////////////////////////////////////////////////////////////
        $scope.SaveNonTradingDay = function () {
            var datefilter = $filter('date');
            $scope.nonTradingDayMaster.frm_dt = datefilter($scope.nonTradingDayMaster.frm_dt, 'dd/MM/yyyy');
            $scope.nonTradingDayMaster.from_date = dateconfigservice.FullDateUKtoDateKey($scope.nonTradingDayMaster.frm_dt);

            $scope.nonTradingDayMaster.to_dt = datefilter($scope.nonTradingDayMaster.to_dt, 'dd/MM/yyyy');
            $scope.nonTradingDayMaster.to_date = dateconfigservice.FullDateUKtoDateKey($scope.nonTradingDayMaster.to_dt);


            var text = dropdownservice.getSelectedText($scope.non_trading_typeList, $scope.nonTradingDayMaster.non_trading_type_id);
            if ($scope.nonTradingDayMaster.non_trading_type_id == '') {
                toastr.error('Please select Non trading Type');
            }
            else if (angular.uppercase(text) == 'WEEKLY') {
                $scope.nonTradingDayMaster.input_info = '';
                if ($scope.nonTradingDayMaster.Sunday == '1') {
                    $scope.nonTradingDayMaster.input_info = $scope.nonTradingDayMaster.input_info + 'Sunday,'
                }
                if ($scope.nonTradingDayMaster.Monday == '1') {
                    $scope.nonTradingDayMaster.input_info = $scope.nonTradingDayMaster.input_info + 'Monday,'
                }
                if ($scope.nonTradingDayMaster.Tuesday == '1') {
                    $scope.nonTradingDayMaster.input_info = $scope.nonTradingDayMaster.input_info + 'Tuesday,'
                }
                if ($scope.nonTradingDayMaster.Wednesday == '1') {
                    $scope.nonTradingDayMaster.input_info = $scope.nonTradingDayMaster.input_info + 'Wednesday,'
                }
                if ($scope.nonTradingDayMaster.Friday == '1') {
                    $scope.nonTradingDayMaster.input_info = $scope.nonTradingDayMaster.input_info + 'Friday,'
                }
                if ($scope.nonTradingDayMaster.Saturday == '1') {
                    $scope.nonTradingDayMaster.input_info = $scope.nonTradingDayMaster.input_info + 'Saturday,'
                }
                $scope.nonTradingDayMaster.input_info = $scope.nonTradingDayMaster.input_info.substring(0, $scope.nonTradingDayMaster.input_info.length - 1);

            }
            else if (angular.uppercase(text) == 'ON DEMAND') {
                $scope.nonTradingDayMaster.input_info = '';
            }
            else if (angular.uppercase(text) == 'YEARLY') {
                $scope.nonTradingDayMaster.input_info = '';
                $scope.nonTradingDayMaster.input_info = $scope.nonTradingDayMaster.month + $scope.nonTradingDayMaster.day;

            }
            $http({
                method: 'POST',
                url: '/Trade/Trade/SaveNewNonTradingDay',
                data: $scope.nonTradingDayMaster
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    //$location.path('/InvestorList');

                }
                else {
                    toastr.error(data.errorMessage);
                }
            });
        };


    })