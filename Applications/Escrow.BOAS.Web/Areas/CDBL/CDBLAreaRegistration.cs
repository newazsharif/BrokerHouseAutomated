using System.Web.Mvc;

namespace Escrow.BOAS.Web.Areas.CDBL
{
    public class CDBLAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "CDBL";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                "CDBL_default",
                "CDBL/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}