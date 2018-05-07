using Escrow.Service.Models;
using Escrow.Utility.Interfaces;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Escrow.Service.Controllers
{
    public class DropdownController : ApiController
    {
        // GET api/<controller>

        public DropdownController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public DropdownController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;

        }

        public UserManager<ApplicationUser> UserManager { get; private set; }


        #region global variables

        private static IGenericFactory<Escrow.BOAS.InstrumentManagement.Models.tblInstrument> instrumentFactory;

        private IReadOnlyFactory<Escrow.Security.Models.tblBrokerInformation> brokerFactory;

        #endregion

        [HttpGet]
        public HttpResponseMessage getDdlInstrument(string BrokerName)
        {
            try
            {
                brokerFactory = new Escrow.Security.Factories.BrokerFactory();
                decimal membership_id = brokerFactory.GetAll().Where(a => a.short_name == BrokerName).Select(a => a.membership_id).FirstOrDefault();

                instrumentFactory = new Escrow.BOAS.InstrumentManagement.Factories.InstrumentFactory();

                var obj = instrumentFactory.GetAll().Where(a=>a.membership_id == membership_id)
                    .Select(a => new
                    {
                        value = a.id,
                        text = a.security_code
                    }).ToList();

                return Request.CreateResponse(HttpStatusCode.OK, obj);
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                instrumentFactory.Dispose();
            }
        }

        public HttpResponseMessage getDdlBroker()
        {
            try
            {
                brokerFactory = new Escrow.Security.Factories.BrokerFactory();


                var obj = brokerFactory.GetAll()
                    .Select(a => new
                    {
                        value = a.membership_id,
                        text = a.Name,
                        a.membership_id,
                    }).ToList();

                return Request.CreateResponse(HttpStatusCode.OK, new { broker = obj });
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                brokerFactory.Dispose();
            }
        }

    }
}