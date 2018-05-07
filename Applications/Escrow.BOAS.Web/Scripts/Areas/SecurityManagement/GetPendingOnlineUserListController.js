angular.module('myApp').controller('GetPendingOnlineUserListController', function ($scope, $window, $http, $location, $routeParams, $filter, isundefinedornullservice, globalvalueservice) {

    $scope.selectAll = function (displayedCollection, allSelect) {
        if (allSelect === true) {
            for (var i = 0; i < displayedCollection.length; i++) {
                displayedCollection[i].selected = true;
            }
        } else {
            for (var i = 0; i < displayedCollection.length; i++) {
                displayedCollection[i].selected = false;
            }
        }

    };
    $scope.changeSelectAll = function (selected, displayedCollection) {
        if (!selected) {
            return false;
        }
        else {
            return isAllSelected(displayedCollection);
        }
    };

    function isAllSelected(displayedCollection) {
        //if ($scope.displayedCollection.length === 0) {
        //    var selectAll = false;
        //}
        var selectAll = true;
        var goLoop = true;
        for (var i = 0; i < displayedCollection.length; i++) {
            if (displayedCollection[i].selected === false) {
                goLoop = false;
                selectAll = false;
            }
        }
        return selectAll;
    }


    $scope.LoadUserListForApprove = function()
    {
        $scope.rowCollection = [];
        $http.get('/Account/GetAllPendingOnlineUser')
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
    }

    $scope.ApproveSelectedUsers = function()
    {
        var SelectedInvestors = [];
        var SelectedUserId = [];
        if ($scope.rowCollection == undefined || $scope.rowCollection.length == 0) {

            toastr.error("No pending user available");
            // $scope.flag = 1;
        }
        else {
            for (var j = 0; j < $scope.displayedCollection.length; j++) {
                if ($scope.displayedCollection[j].selected) {
                    SelectedInvestors.push($scope.displayedCollection[j].client_id);
                    SelectedUserId.push($scope.displayedCollection[j].UserId);
                }
            }

            if (SelectedInvestors.length == 0 || SelectedInvestors.length == undefined) {
                toastr.error("please select user");
            }
            else {
                $http({
                    method: 'POST',
                    url: '/Account/ApproveOnlinePendingUsers',
                    data: SelectedInvestors
                }).success(function (data) {
                    if (data.success) {                        
                        $scope.LoadUserListForApprove();
                        $scope.allSelect = false;
                        toastr.success('Approve successful');
                    } else {
                        toastr.error(data.errorMessage);
                    }
                }).
               error(function (XMLHttpRequest, textStatus, errorThrown) {
                   toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
               });
            }
        }       
    }
});