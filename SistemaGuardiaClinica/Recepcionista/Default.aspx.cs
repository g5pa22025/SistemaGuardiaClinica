using System;
using Entidades;

namespace SistemaGuardiaClinica.Recepcionista
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar sesión manualmente
            var usuario = (Usuario)Session["Usuario"];

            if (usuario == null)
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            // Mostrar información del usuario
            lblUsuario.InnerText = $"{usuario.Nombre} {usuario.Apellido} - {usuario.Rol.Nombre}";
            lblRol.InnerText = usuario.Rol.Nombre;

            // Solo permitir acceso a recepcionistas
            if (usuario.Rol.Nombre != "Recepcionista")
            {
                Response.Redirect("../Default.aspx");
                return;
            }
        }
    }
}