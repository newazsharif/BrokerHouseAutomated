angular.module('myApp').controller('ImportShareLimitController', function ($scope, $http, $filter, dateconfigservice, globalvalueservice, Upload, isundefinedornullservice) {

    $('#pageTitle').text("--- Import Share Limits");

    $scope.isTextUploaded = false;

    $scope.file_name = "";

    $scope.loadDropdowns = function () {
        $scope.import_dt = globalvalueservice.getProcessDate();

        $scope.loadOmnibusMaster();
    };

    $scope.loadOmnibusMaster = function () {
        $scope.chargeList = null;
        $http.get('/Trade/ImportShareLimit/getOmnibusMasterDdlList/').
          success(function (data) {
              $scope.omnibusMasterList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.uploadShareLimit = function (txtFile) {
        if (isundefinedornullservice.isUndefinedOrNull(txtFile)) {
            toastr.error("Please select a file to upload!!!!!");
        }
        else {
            var import_dt = dateconfigservice.FullDateUKtoDateKey($scope.import_dt);

            

            Upload.upload(
             {
                 method: 'POST',
                 url: '/Trade/ImportShareLimit/uploadShareLimitFromText',
                 fields: { import_dt: import_dt, omnibus_master_id: $scope.omnibus_master_id },
                 file: txtFile,
                 async: true

             })
         .success(function (data) {
             if (data.success) {
                 $scope.isTextUploaded = true;
                 $scope.file_name = $('#FileUpload').val();
                 
                 toastr.success('File successfully uploaded. Please click Save button for process.');
             }
             else {
                 $scope.isTextUploaded = true;
                 $scope.file_name = $('#FileUpload').val();
                 
                 toastr.error(data.errorMsg);
             }
         })
         .error(function (XMLHttpRequest, textStatus, errorThrown) {
             
             toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
         });
        }
    };

    $scope.saveImpShareLimit = function () {
        if ($scope.newImpShareLimitForm.$valid) {
            var datefilter = $filter('date');
            if ($scope.isTextUploaded) {
                var import_dt = dateconfigservice.FullDateUKtoDateKey($scope.import_dt);

                

                $http({
                    method: 'POST',
                    url: '/Trade/ImportShareLimit/importShareLimits',
                    data: { import_dt: import_dt, omnibus_master_id: $scope.omnibus_master_id, file_name: $scope.file_name }
                }).success(function (data) {
                    if (data.success) {
                        $scope.isTextUploaded = false;
                        
                        toastr.success("Save Successfully");
                    }
                    else {
                        
                        toastr.error(data.errorMessage);
                    }
                }).
                  error(function (XMLHttpRequest, textStatus, errorThrown) {
                      
                      toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
                  });
            }
            else {
                toastr.error("Please upload a file to save...");
            }
        }
    };

    $scope.ImportShareLimitList = function () {
        $scope.rowCollection = [];
        $http.get('/Trade/ImportShareLimit/getImpShareLimitList/').
          success(function (data) {
              if (data.success) {
                  $scope.rowCollection = data.importShareLimitList;
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