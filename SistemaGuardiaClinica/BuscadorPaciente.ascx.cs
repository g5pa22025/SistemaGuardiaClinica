using System;
using System.Web.UI;
using Entidades;
using Negocio.Services;

namespace SistemaGuardiaClinica
{
    public partial class BuscadorPaciente : UserControl
    {
        public event EventHandler<int> PacienteSeleccionado;

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            var service = new PacienteService();
            var resultados = service.BuscarPacientes(txtDNIBuscar.Text, txtApellidoBuscar.Text);

            gvResultados.DataSource = resultados;
            gvResultados.DataBind();
            gvResultados.Visible = true;
        }

        protected void gvResultados_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Seleccionar")
            {
                int pacienteId = Convert.ToInt32(e.CommandArgument);
                PacienteSeleccionado?.Invoke(this, pacienteId);
            }
        }
    }
}