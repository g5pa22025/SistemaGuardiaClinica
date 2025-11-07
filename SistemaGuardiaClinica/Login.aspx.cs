using Entidades;       
using Negocio.Services;
using System;
using System.Web;
using System.Web.UI;

namespace SistemaGuardiaClinica
{
    public partial class Login : Page
    {
        private void SetMensaje(string texto, bool ok = false)
        {
            if (lblMensaje == null) return;
            lblMensaje.CssClass = ok ? "text-success d-block" : "text-danger d-block";
            lblMensaje.Text = texto ?? string.Empty;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();

            if (!IsPostBack)
            {
                // Si por alguna razón venís con sesión previa, no auto-redirigimos para evitar bucles.
                // Mostramos el login siempre; el usuario decide salir o continuar logueándose.
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                SetMensaje(string.Empty);

                var email = txtEmail.Text.Trim();
                var password = txtPassword.Text; // si usás hash, acá iría el hash

                var auth = new AuthService();
                var usuario = auth.Login(email, password);

                if (usuario == null)
                {
                    SetMensaje("Usuario o contraseña inválidos.");
                    btnLogin.Enabled = true;
                    return;
                }

                // Sesión limpia + usuario logueado
                Session.Clear();
                Session["Usuario"] = usuario;

                // (Opcional) cookie de FormsAuth
                System.Web.Security.FormsAuthentication.SetAuthCookie(usuario.Email, false);

                // Redirigir SIEMPRE a la única home
                Response.Redirect("~/Default.aspx", endResponse: false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                SetMensaje("Ocurrió un error en el login: " + ex.Message);
                btnLogin.Enabled = true;
            }
        }
    }
}