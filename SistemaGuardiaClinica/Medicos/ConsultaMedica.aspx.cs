using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Negocio.Services; 
using Entidades;

namespace SistemaGuardiaClinica.Medicos
{
    public partial class ConsultaMedica : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SetUsuarioEnHeader();

            if (!IsPostBack)
                Bind();
        }

        private void SetUsuarioEnHeader()
        {
            // (Código para setear el usuario del MasterPage)
            var lblUsuario = Master.FindControl("lblUsuario") as Label;
            if (lblUsuario != null)
            {
                lblUsuario.Text = "Médico (Ejemplo)";
            }
        }

        private void Bind()
        {
            try
            {
                var svc = new GuardiaService();

                // saco la especialidad del médico logueado
                var especialidad = ObtenerEspecialidadMedicoActual();

                // solo guardias de esa especialidad (Triaje / Atendido)
                var lista = svc.ObtenerPacientesEnTriajePorEspecialidad(especialidad);

                rpTriageados.DataSource = lista;
                rpTriageados.DataBind();
            }
            catch (Exception ex)
            {
                phMsg.Controls.Add(new Literal
                {
                    Text = $"<div class='alert alert-danger'>Error al cargar la lista: {ex.Message}</div>"
                });
            }
        }

        // Se dispara al presionar "Finalizar Consulta" en el modal
        protected void btnFinalizarConsulta_Click(object sender, EventArgs e)
        {
            try
            {
                if (!int.TryParse(hfConsultaGuardiaId.Value, out var guardiaId) || guardiaId <= 0)
                    throw new Exception("Guardia inválida.");

                var notas = (txtConsultaNotas.Text ?? "").Trim();
                if (string.IsNullOrWhiteSpace(notas))
                    throw new Exception("Debe ingresar el diagnóstico o notas.");

                // Obtenemos el Id del médico desde la sesión
                int medicoId = 0;

                if (Session["UsuarioId"] != null)
                    medicoId = Convert.ToInt32(Session["UsuarioId"]);

                if (medicoId <= 0 && Session["Usuario"] is Usuario u && u.Id > 0)
                    medicoId = u.Id;

                if (medicoId <= 0)
                    throw new Exception("No se encontró el Id del médico en sesión.");

                var svc = new GuardiaService();

                string diagnostico = notas;
                string medicamentos = "";

                if (chkTieneMedicamentos.Checked)
                    medicamentos = ddlMedicamentos.SelectedValue; // o SelectedItem.Text

                svc.FinalizarAtencion(guardiaId, medicoId, diagnostico, medicamentos);

                phMsg.Controls.Add(new Literal
                {
                    Text = "<div class='alert alert-success'>Consulta finalizada correctamente.</div>"
                });

                Bind(); // se recarga la lista, pero el paciente sigue listado con Estado = "Atendido"
            }
            catch (Exception ex)
            {
                phMsg.Controls.Add(new Literal
                {
                    Text = $"<div class='alert alert-danger'>No se pudo finalizar: {ex.Message}</div>"
                });
            }
        }

        public string GetBadge(int? prioridad)
        {
            int p = prioridad.GetValueOrDefault(1);
            string css;

            switch (p)
            {
                case 1:
                    css = "bg-danger";        // Rojo - Inmediato
                    break;
                case 2:
                    css = "bg-prio-orange";   // Naranja - Muy urgente
                    break;
                case 3:
                    css = "bg-warning";       // Amarillo - Urgente
                    break;
                case 4:
                    css = "bg-success";       // Verde - Menos urgente
                    break;
                case 5:
                    css = "bg-primary";       // Azul - No urgente
                    break;
                default:
                    css = "bg-secondary";
                    break;
            }

            return $"<span class='badge {css} rounded-pill px-3 py-2'>P{p}</span>";
        }

        // Clase de fila por prioridad (para fondo suave)
        public string GetRowClass(int? prioridad)
        {
            int p = prioridad.GetValueOrDefault(1);
            if (p < 1 || p > 5) p = 5; // por si viene algo raro

            return $"row-pr-{p}";
        }

        public string GetEstadoBadge(string estado)
        {
            estado = (estado ?? "").Trim();

            string css = "bg-secondary";
            string texto = estado;

            if (estado.Equals("Triaje", StringComparison.OrdinalIgnoreCase))
            {
                css = "bg-info";
                texto = "En atención";
            }
            else if (estado.Equals("Atendido", StringComparison.OrdinalIgnoreCase))
            {
                css = "bg-success";
                texto = "Atendido";
            }
            else if (estado.Equals("Espera", StringComparison.OrdinalIgnoreCase))
            {
                css = "bg-warning";
                texto = "En espera";
            }

            return $"<span class='badge {css} rounded-pill px-3 py-2'>{texto}</span>";
        }

        private string ObtenerEspecialidadMedicoActual()
        {
            // En el login guardo el Usuario completo en sesión
            if (Session["Usuario"] is Usuario u && !string.IsNullOrWhiteSpace(u.Especialidad))
                return u.Especialidad;

            return null;
        }
    }
}