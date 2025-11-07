using System;
using Entidades;

namespace SistemaGuardiaClinica.Enfermeria
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var usuario = (Usuario)Session["Usuario"];

            if (usuario == null)
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            lblUsuario.InnerText = $"{usuario.Nombre} {usuario.Apellido} - {usuario.Rol.Nombre}";
            lblRol.InnerText = usuario.Rol.Nombre;

            if (usuario.Rol.Nombre != "Enfermero")
            {
                Response.Redirect("../Default.aspx");
                return;
            }
        }
    }
}