angular.module('myApp').controller('ConstantObjectController', function ($scope, $window, $http, $location, $routeParams) {

    $('#pageTitle').text("--- Constant Object");
    
    $scope.loadObjectList = function () {
        $scope.rowCollection = [];
        $http.get('/Configuration/ConstantObject/getConstantObjectList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.constantObjects;
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

    $scope.DeleteConstantObject = function (row) {
        var isDelete = confirm("Are you sure you want to delete this object!");
        if (isDelete == true) {

            $http.get('/Configuration/ConstantObject/getConstantObjectValueListByObjectId/' + row.object_id).
              success(function (data) {
                  if (data.success) {
                      if (data.constantObjectValue.length > 0) {
                          toastr.error("This object is used in object value, You can not delete it!!!!");
                      }
                      else {
                          $http({
                              method: 'POST',
                              url: '/Configuration/ConstantObject/deleteConstantObject',
                              data: { object_id: row.object_id }
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
                          });
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
    };

    $scope.constantObject = {};
    $scope.saveNewConstantObject = function () {
        if ($scope.newConsForm.$valid) {
            $http({
                method: 'POST',
                url: '/Configuration/ConstantObject/addConstantObject',
                data: $scope.constantObject
            }).success(function (data) {
                if (data.success) {
                    toastr.success("Submitted Successfully");
                    $location.path('/ConstantObject');

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

    $scope.loadConstantObjectById = function () {
        $http.get('/Configuration/ConstantObject/getConstantObjectById/' + $routeParams.object_id).
          success(function (data) {
              if (data.success) {
                  $scope.editConsObject = data.constantObject;
              }
              else {
                  toastr.error(data.errorMessage);
                  $location.path('/ConstantObject');
              }
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
              $location.path('/ConstantObject');
          });
    };

    $scope.editConstantObject = function () {
        if ($scope.editConsForm.$valid) {
            $http({
                method: 'POST',
                url: '/Configuration/ConstantObject/updateConstantObject',
                data: $scope.editConsObject
            }).
                success(function (data) {
                    if (data.success) {
                        toastr.success("Submitted Successfully");
                        $location.path('/ConstantObject');
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

    $scope.refresh = function () {
        $scope.constantObject = {};
    };
})

