using DSCPullServerWeb.Services;
using System;
using System.Reflection;
using System.Web.Mvc;

namespace DSCPullServerWeb.Controllers
{
    public class WebController : Controller
    {
        private IOptions _options;

        public WebController(IOptions options)
        {
            _options = options;

            ViewBag.Title       = _options.Title;
            ViewBag.Description = _options.Description;
            ViewBag.Footer      = _options.Footer;
            ViewBag.InfoServer  = Environment.MachineName;
            ViewBag.InfoVersion = Assembly.GetExecutingAssembly().GetName().Version;
        }

        public ActionResult Home()
        {
            ViewBag.Name = "Home";

            return View();
        }

        public ActionResult Nodes()
        {
            ViewBag.Name = "Nodes";

            return View();
        }

        public ActionResult Reports()
        {
            ViewBag.Name = "Reports";

            return View();
        }

        public ActionResult Configurations()
        {
            ViewBag.Name = "Configurations";

            return View();
        }

        public ActionResult Modules()
        {
            ViewBag.Name = "Modules";

            return View();
        }

        public ActionResult Cmdlets()
        {
            ViewBag.Name = "Cmdlets";

            return View();
        }

        public ActionResult RestApi()
        {
            ViewBag.Name = "REST API";

            return View();
        }
    }
}
