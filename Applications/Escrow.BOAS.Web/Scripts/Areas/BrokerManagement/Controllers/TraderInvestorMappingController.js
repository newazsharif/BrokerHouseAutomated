angular.module('myApp').controller('TraderInvestorMappingController', function ($scope, $window, $http, $location, $routeParams, $filter, dateconfigservice, globalvalueservice) {

    $('#pageTitle').text("--- Trader Investor Mapping");

    $scope.open = function ($event, opened) {
        $event.preventDefault();
        $event.stopPropagation();

        $scope[opened] = true;
    };

    $scope.displayedCollection = [];

    $scope.traderInvMap = {};
    $scope.loadAllTrader = function () {
        $scope.rowCollection = [];
        $http.get('/BrokerManagement/TraderInvestorMapping/getTraderList/').
          success(function (data) {
              $scope.traderList = data;
          }).
          error(function (XMLHttpRequest, textStatus, errorThrown) {
              toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
          });
    };

    $scope.loadDropdowns = function () {
        $scope.loadAllTrader();
    };

    $scope.loadInvestors = function () {
       
        $scope.rowCollection = [];
        $scope.searchDisplayedCollection = [];
        var id = $scope.traderInvMap.trader_id;
        $http.get('/BrokerManagement/TraderInvestorMapping/LoadInvestors/' + id).
        success(function (data) {
            if (data.success) {
                $scope.rowCollection = data.investorList;
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

    $scope.getSearchResult = function()
    {
        if ($scope.newTraderInvMapForm.$valid) {
            $scope.searchRowCollection = [];
            var search = $scope.traderInvMap.search;
            var trader = $scope.traderInvMap.trader_id;
            $http.get('/BrokerManagement/TraderInvestorMapping/GetSearchInvestors?search=' + search + '&trader_id=' + trader)
            .success(function (data) {
                if (data.success) {
                    $scope.searchRowCollection = data.searchInvestorList;
                    $scope.searchDisplayedCollection = [].concat($scope.searchRowCollection);
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
            toastr.error("Please select Trader");
        }
    }

    $scope.hoverThis = function (id)
    {
        for (var i = 0; i < $scope.searchDisplayedCollection.length; i++)
        {
            if($scope.searchDisplayedCollection[i].client_id == id)
            {
                var client_id = $scope.searchDisplayedCollection[i].client_id;
                var bo_code = $scope.searchDisplayedCollection[i].bo_code;
                var inv_name = $scope.searchDisplayedCollection[i].first_holder_name;
                var trader = $scope.searchDisplayedCollection[i].trader;
            }
        }
        
        $scope.info = "Client id: " + client_id + ",  BO Code: " + bo_code + "\n" + ",  Name: " + inv_name + "\n" + ", Trader: " + trader;
    }
 

    $scope.saveTraderInvMap = function () {
        var client_id = [];
        var newtrader_id = [];
        if (client_id.length != 0)
        {
            for (var i = 0; i < $scope.displayedCollection.length; i++) {
                client_id.push($scope.displayedCollection[i].client_id);
                newtrader_id.push($scope.displayedCollection[i].trader_id);
            }

            $http({
                method: 'POST',
                url: '/BrokerManagement/TraderInvestorMapping/saveTraderInvMap',
                data: { clients: client_id, traders: newtrader_id }
            }).success(function (data) {
                toastr.success("Successfully Maped");
                $scope.loadInvestors();
            })
            .error(function (XMLHttpRequest, textStatus, errorThrown) {
                toastr.error(XMLHttpRequest + ": " + textStatus + ": " + errorThrown, 'Error!!!');
            });
        }
        else {
            toastr.error("No item selected Please add Investor in Investors list");
        }
         
    }

    $scope.selected = [];

    // Function to get data for all selected items
    $scope.selectAll = function () {

        // if there are no items in the 'selected' array, 
        // push all elements to 'selected'
        if ($scope.selected.length === 0) {
            for (var i = 0; i < $scope.searchDisplayedCollection.length; i++) {
                $scope.selected.push($scope.searchDisplayedCollection[i].client_id);
            }

            // if there are items in the 'selected' array, 
            // add only those that ar not
        } else if ($scope.selected.length > 0 && $scope.selected.length != $scope.searchDisplayedCollection.length) {

            for (var i = 0; i < collection.length; i++) {
                var found = $scope.selected.indexOf($scope.searchDisplayedCollection[i].client_id);
                if (found == -1) {
                    $scope.selected.push($scope.searchDisplayedCollection[i].client_id);
                }
            }

            // Otherwise, remove all items
        } else {

            $scope.selected = [];
        }

    };

    // Function to get data by selecting a single row
    $scope.select = function (id) {

        var found = $scope.selected.indexOf(id);

        if (found == -1) {
            $scope.selected.push(id);        
        }
        else {
            $scope.selected.splice(found, 1);
        }
    }


    $scope.displayedCollection = [];
    $scope.searchInvToInvList = function ()
    {
        if ($scope.selected.length != 0)
        {
            try {

                for (var i = 0; i < $scope.selected.length; i++) {
                    var index = $scope.selected[i];
                    $scope.displayedCollection.push(addSearchedItem(index));

                }
                $scope.selected = [];
                toastr.success("Search Investors are Successfully Added to Investors List");

            }
            catch (Exception) {
                toastr.error("Unable to Move Investors!");
            }
        }
        else if ($scope.selected.length == 0)
        {
            toastr.error("No item selected Please Select Investor from Search list");
        }
        else {
            toastr.error("Unable to Move Investors!");
        }
       
    }


    function addSearchedItem(id) {
        try{
            for (var i = 0; i <= $scope.searchDisplayedCollection.length; i++)
            {
                if($scope.searchDisplayedCollection[i].client_id == id)
                {
                    var client_id = $scope.searchDisplayedCollection[i].client_id;
                    var bo_code = $scope.searchDisplayedCollection[i].bo_code;
                    var first_holder_name = $scope.searchDisplayedCollection[i].first_holder_name;                   
                    $scope.searchDisplayedCollection.splice(i, 1);
                    //$scope.itemsByPage = 10;
                    return {
                        client_id: client_id,
                        bo_code: bo_code,
                        first_holder_name: first_holder_name,
                        trader_id: $scope.traderInvMap.trader_id
                    }               
                                      
                }                
            }          
        }
        catch(Exception)
        {
            toastr.error("Error");
        }
        
    }
  
    $scope.refresh = function () {
        $scope.tradaerInformation = {};
    };
})