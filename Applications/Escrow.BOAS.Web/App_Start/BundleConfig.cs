using BundleTransformer.Core.Bundles;
using BundleTransformer.Core.Orderers;
using BundleTransformer.Core.Transformers;
using System.Web.Optimization;

namespace Escrow.BOAS.Web
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.UseCdn = true;
            var cssTransformer = new StyleTransformer();
            var jsTransformer = new ScriptTransformer();
            var nullOrderer = new NullOrderer();

            var cssBundle = new StyleBundle("~/bundles/css");
            cssBundle.Include("~/Content/Site.less", "~/Content/bootstrap-theme.css", "~/Content/toastr-responsive.css", "~/Content/toastr.css");
            cssBundle.Transforms.Add(cssTransformer);
            cssBundle.Orderer = nullOrderer;
            bundles.Add(cssBundle);
            var jqueryBundle = new ScriptBundle("~/bundles/jquery");
            jqueryBundle.Include("~/Scripts/jquery-{version}.js");
            jqueryBundle.Transforms.Add(jsTransformer);
            jqueryBundle.Orderer = nullOrderer;
            bundles.Add(jqueryBundle);

            var jqueryvalBundle = new ScriptBundle("~/bundles/jqueryval");
            jqueryvalBundle.Include("~/Scripts/jquery.validate*");
            jqueryvalBundle.Transforms.Add(jsTransformer);
            jqueryvalBundle.Orderer = nullOrderer;
            bundles.Add(jqueryvalBundle);

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.

            var modernizrBundle = new ScriptBundle("~/bundles/modernizr");
            modernizrBundle.Include("~/Scripts/modernizr-*");
            modernizrBundle.Transforms.Add(jsTransformer);
            modernizrBundle.Orderer = nullOrderer;
            bundles.Add(modernizrBundle);

            var bootstrapBundle = new ScriptBundle("~/bundles/bootstrap");
            bootstrapBundle.Include("~/Scripts/bootstrap.js", "~/Scripts/respond.js");
            bootstrapBundle.Transforms.Add(jsTransformer);
            bootstrapBundle.Orderer = nullOrderer;
            bundles.Add(bootstrapBundle);

            var angularBundle = new ScriptBundle("~/bundles/angularjs");
            angularBundle.Include("~/Scripts/angular.js", "~/Scripts/angular-route.js", "~/Scripts/angular-animate.js");
            angularBundle.Transforms.Add(jsTransformer);
            angularBundle.Orderer = nullOrderer;
            bundles.Add(angularBundle);

            var appBundle = new ScriptBundle("~/bundles/appjs");
            appBundle.Include("~/Scripts/app.js");
            appBundle.Transforms.Add(jsTransformer);
            appBundle.Orderer = nullOrderer;
            bundles.Add(appBundle);

            var datePickerBundle = new ScriptBundle("~/bundles/datePickerjs");
            datePickerBundle.Include("~/Scripts/datepicker.js");
            datePickerBundle.Transforms.Add(jsTransformer);
            datePickerBundle.Orderer = nullOrderer;
            bundles.Add(datePickerBundle);

            var smartTableBundle = new ScriptBundle("~/bundles/smartTablejs");
            smartTableBundle.Include("~/Scripts/smart-table.js");
            smartTableBundle.Transforms.Add(jsTransformer);
            smartTableBundle.Orderer = nullOrderer;
            bundles.Add(smartTableBundle);

            var routeBundle = new ScriptBundle("~/bundles/routejs");
            routeBundle.Include("~/Scripts/Areas/Route.js");
            routeBundle.Transforms.Add(jsTransformer);
            routeBundle.Orderer = nullOrderer;
            bundles.Add(routeBundle);

            var toastrBundle = new ScriptBundle("~/bundles/toastr");
            toastrBundle.Include("~/Scripts/toastr.js");
            toastrBundle.Transforms.Add(jsTransformer);
            toastrBundle.Orderer = nullOrderer;
            bundles.Add(toastrBundle);

            var serviceBundle = new ScriptBundle("~/bundles/service");
            serviceBundle.Include("~/Scripts/Services/dateConfigService.js", "~/Scripts/Services/dropdownService.js", "~/Scripts/Services/globalValueService.js", "~/Scripts/Services/isUndefinedOrNullService.js");
            serviceBundle.Transforms.Add(jsTransformer);
            serviceBundle.Orderer = nullOrderer;
            bundles.Add(serviceBundle);

            var directiveBundle = new ScriptBundle("~/bundles/directive");
            directiveBundle.Include("~/Scripts/Directives/commonDirective.js", "~/Scripts/Directives/pageSelect.directive.js", "~/Scripts/Directives/rowSelectDirective.js", "~/Scripts/Directives/rowSelectAllDirective.js", "~/Scripts/Directives/modalDirective.js");
            directiveBundle.Transforms.Add(jsTransformer);
            directiveBundle.Orderer = nullOrderer;
            bundles.Add(directiveBundle);


            #region Angular module controllers

            var configurationBundle = new ScriptBundle("~/bundles/configurationjs");
            configurationBundle.Include("~/Scripts/Areas/Configuration/Controllers/ConstantObjectController.js", "~/Scripts/Areas/Configuration/Controllers/ConstantObjectValueController.js", "~/Scripts/Areas/Configuration/Controllers/BrokerBranchController.js");
            configurationBundle.Transforms.Add(jsTransformer);
            configurationBundle.Orderer = nullOrderer;
            bundles.Add(configurationBundle);

            var brokerManagementnBundle = new ScriptBundle("~/bundles/brokerManagementjs");
            brokerManagementnBundle.Include("~/Scripts/Areas/Configuration/Controllers/ConstantObjectController.js");
            brokerManagementnBundle.Transforms.Add(jsTransformer);
            brokerManagementnBundle.Orderer = nullOrderer;
            bundles.Add(brokerManagementnBundle);

            #endregion
        }
    }
}