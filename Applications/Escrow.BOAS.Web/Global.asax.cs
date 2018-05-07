using Escrow.BOAS.Web.SignalRHub;
using Microsoft.AspNet.SignalR;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace Escrow.BOAS.Web
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            RegisterNotification();
        }

        private void RegisterNotification()
        {
            //Get the connection string from the Web.Config file. Make sure that the key exists and it is the connection string for the Notification Database and the NotificationList Table that we created

            string connectionString = ConfigurationManager.ConnectionStrings["BOASConnectionString"].ConnectionString;

            //We have selected the entire table as the command, so SQL Server executes this script and sees if there is a change in the result, raise the event
            string commandText = @"
                                    Select
                                        [Service].tblPlaceOrder.id,
                                        [Service].tblPlaceOrder.client_id,
                                        [Service].tblPlaceOrder.instrument_id,
                                        [Service].tblPlaceOrder.order_type,
                                        [Service].tblPlaceOrder.quantity,
                                        [Service].tblPlaceOrder.market_price,
                                        [Service].tblPlaceOrder.negotiable,
                                        [Service].tblPlaceOrder.order_date,
                                        [Service].tblPlaceOrder.approve_by,
                                        [Service].tblPlaceOrder.approve_date,
                                        [Service].tblPlaceOrder.membership_id,
                                        [Service].tblPlaceOrder.changed_user_id, 
                                        [Service].tblPlaceOrder.changed_date, 
                                        [Service].tblPlaceOrder.is_dirty, 
                                        [Service].tblPlaceOrder.cancel_by                                   
                                    From
                                        [Service].tblPlaceOrder                                     
                                    ";

            //Start the SQL Dependency
            SqlDependency.Start(connectionString);
            using (SqlConnection connection = new SqlConnection(connectionString))
            {

                using (SqlCommand command = new SqlCommand(commandText, connection))
                {
                    connection.Open();
                    var sqlDependency = new SqlDependency(command);


                    sqlDependency.OnChange += new OnChangeEventHandler(sqlDependency_OnChange);

                    // NOTE: You have to execute the command, or the notification will never fire.
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                    }
                }
            }
        }

        DateTime LastRun;
        private void sqlDependency_OnChange(object sender, SqlNotificationEventArgs e)
        {

            if (e.Info == SqlNotificationInfo.Insert || e.Info == SqlNotificationInfo.Update)
            {
                //This is how signalrHub can be accessed outside the SignalR Hub Notification.cs file
                var context = GlobalHost.ConnectionManager.GetHubContext<NotificationHub>();

                context.Clients.All.response("dbchange");

            }
            //Call the RegisterNotification method again
            RegisterNotification();
        }
    }
}
