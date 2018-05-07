angular.module('myApp').controller('_PendingOrderNotificationController', function ($rootScope, $scope, notification) {

    notification.client.response = function onNewMessage(message) {
        if (message == "dbchange") {
            var BrokerName = $('#BrokerName').val();
            var UserName = $('#UserName').val();
            notification.server.getNotification(BrokerName, UserName);
            $scope.$apply();
        }
        else {
            displayMessage(message);
            $scope.$apply();
        }
    };

    function displayMessage(message) {
        $scope.pending = message;
        $rootScope.pending = message;
    }
});