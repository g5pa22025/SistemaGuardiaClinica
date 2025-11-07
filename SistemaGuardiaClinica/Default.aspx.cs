using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Entidades; 

namespace SistemaGuardiaClinica
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // No cache para que el back del browser no muestre una página vieja
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();

            var usuario = Session["Usuario"] as Usuario;
            if (usuario == null)
            {
                Response.Redirect("~/Login.aspx", endResponse: false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                // Cabecera con nombre y rol
                var rolNombre = usuario.Rol != null ? usuario.Rol.Nombre : "Sin rol";
                lblUsuario.Text = $"{HttpUtility.HtmlEncode(usuario.Nombre)} ({HttpUtility.HtmlEncode(rolNombre)})";

                // Mostrar panel según rol
                MostrarPanelPorRol(rolNombre);
            }
        }

        private void MostrarPanelPorRol(string rolNombre)
        {
            // Limpiar visibilidad
            panelRecepcion.Visible = false;
            panelEnfermeria.Visible = false;
            panelMedico.Visible = false;

            switch ((rolNombre ?? string.Empty).Trim())
            {
                case "Recepcionista":
                    panelRecepcion.Visible = true;
                    break;

                case "Enfermero":
                case "Enfermera":
                    panelEnfermeria.Visible = true;
                    break;

                case "Medico":
                case "Médico":
                    panelMedico.Visible = true;
                    break;

                default:
                    // Si no coincide, mostramos un aviso
                    AgregarMensaje("No se encontró un panel asociado a tu rol. Contactá al administrador.", "warning");
                    break;
            }
        }

        private void AgregarMensaje(string texto, string tipoBootstrap = "info")
        {
            phMsg.Controls.Clear();
            var div = new System.Web.UI.HtmlControls.HtmlGenericControl("div");
            div.Attributes["class"] = $"alert alert-{tipoBootstrap}";
            div.InnerText = texto ?? string.Empty;
            phMsg.Controls.Add(div);
        }
    }
}
