using System;
using Entidades;

namespace SistemaGuardiaClinica.Medicos
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
            lblEspecialidad.InnerText = $"Especialidad: {usuario.Especialidad}";

            if (usuario.Rol.Nombre != "Medico")
            {
                Response.Redirect("../Default.aspx");
                return;
            }
        }
    }
}