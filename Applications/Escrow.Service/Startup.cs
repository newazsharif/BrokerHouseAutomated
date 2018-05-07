using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Escrow.Service.Startup))]
namespace Escrow.Service
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
