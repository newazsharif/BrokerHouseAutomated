using System.Web.Mvc;

namespace Escrow.BOAS.Web.Areas.BrokerManagement
{
    public class BrokerManagementAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "BrokerManagement";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                "BrokerManagement_default",
                "BrokerManagement/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}