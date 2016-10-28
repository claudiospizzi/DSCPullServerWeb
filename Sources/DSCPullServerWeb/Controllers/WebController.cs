using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DSCPullServerWeb.Controllers
{
    public class WebController : Controller
    {
        public ActionResult Home()
        {
            ViewBag.Title = "Home";

            return View();
        }

        public ActionResult Nodes()
        {
            ViewBag.Title = "Nodes";

            return View();
        }

        public ActionResult Reports()
        {
            ViewBag.Title = "Reports";

            return View();
        }

        public ActionResult Configurations()
        {
            ViewBag.Title = "Configurations";

            return View();
        }

        public ActionResult Modules()
        {
            ViewBag.Title = "Modules";

            return View();
        }

        public ActionResult Cmdlets()
        {
            ViewBag.Title = "Cmdlets";

            return View();
        }

        public ActionResult RestApi()
        {
            ViewBag.Title = "REST API";

            return View();
        }
    }
}
