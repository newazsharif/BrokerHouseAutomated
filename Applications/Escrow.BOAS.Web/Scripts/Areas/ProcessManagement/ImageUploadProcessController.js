angular.module('myApp').
    controller('ImageUploadProcessController', function($scope, $http) {
        $scope.Upload = function() {
            $http.get('/processmanagement/activityprocess/upload')
                .success(function(data) {
                    if (data.success) {
                        toastr.success(data.message);
                    } else {
                        toastr.error(data.errorMessage);
                    }
                }).error(function (XMLHttpRequest, textStatus, errorThrown) {
                    toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
                });
        }
    });