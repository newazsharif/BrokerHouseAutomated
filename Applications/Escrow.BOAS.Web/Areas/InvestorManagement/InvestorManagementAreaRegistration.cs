using System.Web.Mvc;

namespace Escrow.BOAS.Web.Areas.InvestorManagement
{
    public class InvestorManagementAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "InvestorManagement";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                "InvestorManagement_default",
                "InvestorManagement/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}