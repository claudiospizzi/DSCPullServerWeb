using System;
using System.Web.Mvc;

namespace DSCPullServerWeb.Helpers
{
    public static class BootstrapExtension
    {
        public static string IsSelected(this HtmlHelper html, string controller = null, string action = null)
        {
            string cssClass = "active";

            string currentController = (string)html.ViewContext.RouteData.Values["controller"];
            string currentAction     = (string)html.ViewContext.RouteData.Values["action"];

            if (String.IsNullOrEmpty(controller))
            {
                controller = currentController;
            }
            if (String.IsNullOrEmpty(action))
            {
                action = currentAction;
            }

            if (controller == currentController && action == currentAction)
            {
                return cssClass;
            }
            else
            {
                return string.Empty;
            }
        }
    }
}
