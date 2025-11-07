using System;
using System.Web;
using System.Web.UI;
using Entidades;
using Negocio.Services;

namespace SistemaGuardiaClinica
{
    public partial class Site : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var usuario = (Usuario)Session["Usuario"];

                // NO redirigir si estamos en la página de Login
                if (usuario == null && !IsLoginPage())
                {
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                if (usuario != null)
                {
                    lblUsuario.Text = $"{usuario.Nombre} {usuario.Apellido} - {usuario.Rol.Nombre}";

                    // Aplicar estilo según rol
                    switch (usuario.Rol.Nombre)
                    {
                        case "Recepcionista":
                            mainNavbar.Attributes["class"] += " navbar-recepcionista";
                            break;
                        case "Enfermero":
                            mainNavbar.Attributes["class"] += " navbar-enfermero";
                            break;
                        case "Medico":
                            mainNavbar.Attributes["class"] += " navbar-medico";
                            break;
                    }
                }
            }
        }

        private bool IsLoginPage()
        {
            return Request.Url.AbsolutePath.ToLower().Contains("login.aspx");
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Login.aspx");
        }
    }
}