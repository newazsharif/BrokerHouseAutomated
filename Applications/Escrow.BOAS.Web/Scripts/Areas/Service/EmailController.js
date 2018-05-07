angular.module('myApp').controller('EmailController', function ($scope, $window, $http, $location, blockUI, $routeParams, $filter, Upload, dateconfigservice, dropdownservice, isundefinedornullservice, globalvalueservice, blockUIConfig) {
    $scope.init = function() {
        $scope.GetAllBranch();
        $scope.GetAllTrader();
        $scope.GetAllSubAccount();
        //$scope.SearchInvestor();
    };

    $scope.to_date = globalvalueservice.getProcessDate();
    var splitted = $scope.to_date.split('/');
    var month = parseInt(splitted[1]) - 2;
    var date = new Date(splitted[2], month, splitted[0]);
    $scope.from_date = date;


    $scope.open = function ($event, opened) {
        $event.preventDefault();
        $event.stopPropagation();

        $scope[opened] = true;
    };

    $scope.GetAllBranch = function() {
        $scope.rowBranchCollection = [];
        $http.get('/Service/Email/GetAllBranch')
            .success(function(data) {
                $scope.rowBranchCollection = data.result;
                $scope.displayedBranchCollection = [].concat($scope.rowBranchCollection);
            });
    };

    $scope.GetAllTrader = function () {
        $scope.rowTraderCollection = [];
        $http.get('/Service/Email/GetAllTrader')
            .success(function (data) {
                $scope.rowTraderCollection = data.result;
                $scope.displayedTraderCollection = [].concat($scope.rowTraderCollection);
            });
    };

    $scope.GetAllSubAccount = function () {
        $scope.rowSubAccCollection = [];
        $http.get('/Service/Email/GetAllSubAccount')
            .success(function (data) {
                $scope.rowSubAccCollection = data.result;
                $scope.displayedSubAccCollection = [].concat($scope.rowSubAccCollection);
            });
    };

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

    $scope.SearchInvestor = function() {
        var selectedTrader = [];
        var selectedBranch = [];
        var selectedSubAcc = [];
        for (var i = 0; i < $scope.displayedTraderCollection.length; i++) {
            if ($scope.displayedTraderCollection[i].selected) {
                selectedTrader.push($scope.displayedTraderCollection[i].id);
            }
        }

        for (var j = 0; j < $scope.displayedBranchCollection.length; j++) {
            if ($scope.displayedBranchCollection[j].selected) {
                selectedBranch.push($scope.displayedBranchCollection[j].id);
            }
        }

        for (var k = 0; j < $scope.displayedSubAccCollection.length; k++) {
            if ($scope.displayedSubAccCollection[k].selected) {
                selectedSubAcc.push($scope.displayedSubAccCollection[k].id);
            }
        }
        $scope.rowInvestorCollection = [];
        $http({
            method: 'POST',
            url: '/Service/Email/SearchInvestor',
            data: { branches: selectedBranch, traders: selectedTrader, subAccs: selectedSubAcc, investors: $scope.investors }
        }).success(function(data) {
            if (data.success) {
                $scope.rowInvestorCollection = data.result;
                $scope.displayInvestorCollection = [].concat($scope.rowInvestorCollection);
                $scope.allInvestorSelect = false;
            } else {
                toastr.error(data.errorMessage);
            }
        }).
            error(function(XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
    };

    $(function () {
        $('#attachFileUpload').on('change', function (evt) {
            var files = $(evt.currentTarget).get(0).files;

            if (files.length > 0) {               
                var atchFilePath = $('#attachFileUpload').val();
            } else {
                var atchFilePath = "";
            }
        });
    });

    //$http.get('Email.cshtml').then(function (data) {
    //    //inform.add('Data received from server');
    //     blockUI.stop();
    //    blockUI.noOpen = true;
    //});

    //$scope.getTags = function ($query) {
    //    blockUI.notShow();
    //    blockUI.stop();
    //    return blogService.getTags($query)
    //};

    $scope.SendMail = function (pdfFile) {
       // blockUIConfig.autoBlock = false;
       
        var tempFile = [];
        if (angular.isUndefined(pdfFile) == false)
        {
            tempFile[0] = pdfFile;
        }
        if(angular.isUndefined(pdfFile) == true)
        {
            tempFile = [] ;
        }          
       
       
            $scope.input = {};

            $scope.rowMailResultCollection = [];
            var SelectedInvestors = [];
            var SelectedInvestorsMail = [];
            if ($scope.rowInvestorCollection == undefined || $scope.rowInvestorCollection.length == 0) {
               
                toastr.error("please search investor first");
               // $scope.flag = 1;
            }
            else
            {
                for (var j = 0; j < $scope.displayInvestorCollection.length; j++) {
                    if ($scope.displayInvestorCollection[j].selected) {
                        SelectedInvestors.push($scope.displayInvestorCollection[j].client_id);
                        SelectedInvestorsMail.push($scope.displayInvestorCollection[j].email_address);
                    }

                }
            }
        $scope.input.investors = SelectedInvestors;
        $scope.input.investorsMail = SelectedInvestorsMail;
        if ($scope.dataCC == null || $scope.dataCC == undefined) {
            var cc = "";
        } else {
            var cc = $scope.dataCC;
        }
        if ($scope.dataBCC == null || $scope.dataBCC == undefined) {
            var bcc = "";
        } else {
            var bcc = $scope.dataBCC;
        }
        if ($scope.dataSUB == null || $scope.dataSUB == undefined) {
            var Sub = "No Subject";
        } else {
            var Sub = $scope.dataSUB;
        }

        if ($scope.dataMsg == null || $scope.dataMsg == undefined) {
            var Msg = "";
        } else {
            var Msg = $scope.dataMsg;
        }

        if ($scope.rptPortfolio)
        {
            var port = 't';
        } else {
            var port = 'f';
        }

        if ($scope.rptClientLedger) {
            var cl = 't';
        } else {
            var cl = 'f';
        }

        if ($scope.rptInstrumentLedger) {
            var il = 't';
        } else {
            var il = 'f';
        }

        if ($scope.rptTrdConfirmationStatementClientWise) {
            var tcs = 't';
        } else {
            var tcs = 'f';
        }

      
        var datefilter = $filter('date');
        var to_dt = datefilter($scope.to_date, 'dd/MM/yyyy');
        var from_dt = datefilter($scope.from_date, 'dd-MM-yyyy');
        if ((SelectedInvestors.length == 0 || SelectedInvestors.length == undefined )&& $scope.rowInvestorCollection != undefined) {
            toastr.error("please select Receiver mail address");
        }
        else if ($scope.rowInvestorCollection != undefined && SelectedInvestors.length != 0 && SelectedInvestors != undefined) {

            // var to_date = datefilter($scope.to_date, 'MM/dd/yyyy');
            blockUI.autoBlock = false;
            //blockUI.noOpen = true;
            Upload.upload({
                url: '/Service/Email/SendMail',
                method: 'POST',
                params: { SelectedInvestors: $scope.input.investors, MailAddress: $scope.input.investorsMail, CC: cc, BCC: bcc, SUB: Sub, MSG: Msg, PORT: port, CL: cl, IL: il, TCS: tcs, FromDate: from_dt, ToDate: to_dt },
                file: tempFile,
                async: true

            })
            .success(function (data) {
                if (data.success) {
                    toastr.success("Mail successfully send");

                    $scope.rowMailResultCollection = data.results;

                    for (var j = 0; j < $scope.displayInvestorCollection.length; j++) {
                        if ($scope.displayInvestorCollection[j].selected) {
                            SelectedInvestors.splice($scope.displayInvestorCollection[j].client_id);
                            SelectedInvestorsMail.splice($scope.displayInvestorCollection[j].email_address);
                            $scope.displayInvestorCollection[j].selected = false;
                        }
                    }
                    $scope.dataCC = "";
                    $scope.dataBCC = "";
                    $scope.dataMsg = "";
                    $scope.dataSUB = "";

                    $scope.rptPortfolio.checked = false;
                    $scope.rptClientLedger.checked = false;
                    $scope.rptInstrumentLedger.checked = false;
                    $scope.rptTrdConfirmationStatementClientWise.checked = false;

                } else {
                    toastr.error(data.errorMessage);
                }
            }).error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
        }

         //  blockUIConfig.autoBlock = true;
        }  
           
});