using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Negocio.Services; // Ya lo tienes
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
            // (Tu código para setear el usuario del MasterPage va aquí)
            var lblUsuario = Master.FindControl("lblUsuario") as Label;
            if (lblUsuario != null)
            {
                lblUsuario.Text = "Médico (Ejemplo)";
                // Aquí iría tu lógica de Session...
            }
        }

        private void Bind()
        {
            try
            {
                var svc = new GuardiaService();

                // --- CAMBIO ---
                // ¡Usamos tu método! Esto es correcto.
                var lista = svc.ObtenerPacientesEnTriaje();

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

        // --- MÉTODO ACTUALIZADO ---
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

                // --- MEJORA USANDO TU SERVICE ---
                var svc = new GuardiaService();

                // Tu service pide diagnóstico y medicamentos por separado.
                // Como el modal simple tiene un solo campo, pasamos
                // todo a 'diagnostico' y dejamos 'medicamentos' vacío.
                // (Si quieres, puedes agregar otro TextBox en el modal para medicamentos)
                string diagnostico = notas;
                string medicamentos = "";

                // Llamamos al método del servicio, que maneja la lógica
                svc.FinalizarAtencion(guardiaId, diagnostico, medicamentos);

                phMsg.Controls.Add(new Literal
                {
                    Text = "<div class='alert alert-success'>Consulta finalizada correctamente.</div>"
                });

                Bind(); // Recargamos la lista (el paciente desaparecerá)
            }
            catch (Exception ex)
            {
                phMsg.Controls.Add(new Literal
                {
                    Text = $"<div class='alert alert-danger'>No se pudo finalizar: {ex.Message}</div>"
                });
            }
        }


        // --- MÉTODOS AYUDANTES (copiados de tu Triage.cs) ---

        public string GetBadge(int? prioridad)
        {
            int p = prioridad.GetValueOrDefault(1);
            string css = p <= 2 ? "bg-success"
                         : p <= 4 ? "bg-warning"
                         : "bg-danger";
            return $"<span class='badge {css} rounded-pill px-3 py-2'>P{p}</span>";
        }

        public string GetRowClass(int? prioridad)
        {
            int p = prioridad.GetValueOrDefault(1);
            if (p <= 2) return "row-pr-1";
            if (p <= 4) return "row-pr-3";
            return "row-pr-5";
        }
    }
}