using System;
using System.Web;

namespace SistemaGuardiaClinica
{
    public partial class Reset : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMensaje.Text = "Esta página limpiará toda la sesión y cookies.";
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            try
            {
                // Limpiar sesión
                Session.Clear();
                Session.Abandon();

                // Limpiar cookies
                HttpCookie sessionCookie = new HttpCookie("ASP.NET_SessionId", "");
                sessionCookie.Expires = DateTime.Now.AddYears(-1);
                Response.Cookies.Add(sessionCookie);

                // Limpiar cache
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));
                Response.Cache.SetNoStore();

                lblMensaje.Text = "La Sesión y las cookies se han limpiado correctamente. Ahora puedes probar el login.";
            }
            catch (Exception ex)
            {
                lblMensaje.Text = $" Error: {ex.Message}";
            }
        }
    }
}