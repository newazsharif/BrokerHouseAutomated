using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Escrow.BOAS.Web.Startup))]
namespace Escrow.BOAS.Web
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.MapSignalR();
            ConfigureAuth(app);
        }
    }
}
