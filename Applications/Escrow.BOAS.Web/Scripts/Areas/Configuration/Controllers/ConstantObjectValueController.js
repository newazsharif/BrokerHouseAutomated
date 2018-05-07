angular.module('myApp').controller('ConstantObjectValueController', function ($scope, $window, $http, $location, $routeParams, isundefinedornullservice) {

    $('#pageTitle').text("--- Constant Object Value");

    $scope.loadAllData = function () {

        $scope.rowCollection = [];
        $scope.constantObjectValueList = null;
        $http.get('/Configuration/ConstantObjectValue/getConstantObjectValueList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.constantObjectValues;
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

    $scope.DeleteConstantObjectValue = function (row) {
        var isDelete = confirm("Are you sure you want to delete this object value!");
        if (isDelete == true) {
            $http({
                method: 'POST',
                url: '/Configuration/ConstantObjectValue/deleteConstantObjectValue',
                data: { object_value_id: row.object_value_id }
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

    $scope.loadConstantObject = function () {
        $scope.constantObjectList = null;
        $http.get('/Configuration/ConstantObjectValue/getConstantObjectDdlList/').
          success(function (data) {
              $scope.constantObjectList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.getDefaultValue = function (object_id) {
        $scope.customStyle = {};
        if (!isundefinedornullservice.isUndefinedOrNull(object_id) && object_id.toString().trim() != "") {
            $http.get('/Configuration/ConstantObjectValue/getDefaultValueByObjectId/' + object_id).
              success(function (data) {
                  if (data.success) {
                      if (data.default_value == "Default: Not set yet") {
                          $scope.customStyle.style = { "color": "red" };
                      }
                      else {
                          $scope.customStyle.style = { "color": "green" };
                      }
                      $scope.default_value = data.default_value;
                  }
                  else {
                      toastr.error(data.errorMessage);
                      $location.path('/ConstantObjectValue');
                  }
              }).
              error(function (XMLHttpRequest, textStatus, errorThrown) {
                  toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
                  $location.path('/ConstantObjectValue');
              });
        }
        else {
            $scope.default_value = "";
        }
    };

    $scope.constantObjectValue = {};
    $scope.saveNewConstantObjectValue = function () {

        if ($scope.newConsValForm.$valid) {
            if (isundefinedornullservice.isUndefinedOrNull($scope.constantObjectValue.is_default) || $scope.constantObjectValue.is_default.toString().trim() == "") {
                $scope.constantObjectValue.is_default = 0;
            }
            $http({
                method: 'POST',
                url: '/Configuration/ConstantObjectValue/addConstantObjectValue',
                data: $scope.constantObjectValue
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/ConstantObjectValue');
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

    $scope.loadConstantObjectAndValue = function () {
        $scope.constantObjectList = null;
        $http.get('/Configuration/ConstantObjectValue/getConstantObjectDdlList/').
          success(function (data) {
              $scope.constantObjectList = data;
              $scope.loadConstantObjectValueById($routeParams.object_value_id);
          }).
          error(function (data) {
              toastr.error("Failed Please try again");
              $location.path('/ConstantObjectValue');
          });
    };

    $scope.loadConstantObjectValueById = function (objectValueId) {
        $http.get('/Configuration/ConstantObjectValue/getConstantObjectValueById/' + objectValueId).
          success(function (data) {
              if (data.success) {
                  $scope.editConsObjVal = data.constantObjectValue;
                  $scope.getDefaultValue(data.constantObjectValue.object_id);
              }
              else {
                  toastr.error(data.errorMessage);
                  $location.path('/ConstantObjectValue');
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
              $location.path('/ConstantObjectValue');
          });
    };

    $scope.editConstantObjectValue = function () {

        if ($scope.editConsValForm.$valid) {
            if (isundefinedornullservice.isUndefinedOrNull($scope.editConsObjVal.is_default) || $scope.editConsObjVal.is_default.toString().trim() == "") {
                $scope.editConsObjVal.is_default = 0;
            }
            $http({
                method: 'POST',
                url: '/Configuration/ConstantObjectValue/updateConstantObjectValue',
                data: $scope.editConsObjVal
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/ConstantObjectValue');
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
        $scope.constantObjectValue = {};
    };
})