angular.module('myApp').controller('OrderPlacedController', function ($scope, $window, $http, globalvalueservice) {

    $('#pageTitle').text("--- Order Placed");

    $scope.loadOrderPlacedList = function () {
        $http.get('/Order/OrderPlaced/getOrderPlacedList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.orderPlacedList;
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
})