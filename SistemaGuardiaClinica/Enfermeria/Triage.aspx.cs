using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Negocio.Services;
using Entidades;

namespace SistemaGuardiaClinica.Enfermeria
{
    public partial class Triage : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SetUsuarioEnHeader();

            if (!IsPostBack)
                Bind();
        }

        private void SetUsuarioEnHeader()
        {
            // Buscar el Label del master
            var lblUsuario = Master.FindControl("lblUsuario") as Label;
            if (lblUsuario == null) return;

            string nombre = null;
            string apellido = null;

            if (Session["UsuarioNombre"] != null)
            {
                nombre = Session["UsuarioNombre"] as string;
                apellido = Session["UsuarioApellido"] as string;
            }

            if ((string.IsNullOrWhiteSpace(nombre) || string.IsNullOrWhiteSpace(apellido)) &&
                Session["Usuario"] is Usuario u)
            {
                nombre = u.Nombre;
                apellido = u.Apellido;
            }

            if (!string.IsNullOrWhiteSpace(nombre) || !string.IsNullOrWhiteSpace(apellido))
                lblUsuario.Text = $"{apellido}, {nombre}".Trim(' ', ',');
            else
                lblUsuario.Text = "Usuario";
        }

        private void Bind()
        {
            try
            {
                var svc = new GuardiaService();
                var lista = svc.ObtenerPacientesEnEspera(); // Espera ordenado por prioridad/fecha
                rpEspera.DataSource = lista;
                rpEspera.DataBind();
            }
            catch (Exception ex)
            {
                phMsg.Controls.Add(new Literal
                {
                    Text = $"<div class='alert alert-danger'>Error al cargar la lista: {ex.Message}</div>"
                });
            }
        }

        // Badge de prioridad
        public string GetBadge(int? prioridad)
        {
            int p = prioridad.GetValueOrDefault(1);
            string css = p <= 2 ? "bg-success"
                       : p <= 4 ? "bg-warning"
                       : "bg-danger";
            return $"<span class='badge {css} rounded-pill px-3 py-2'>P{p}</span>";
        }

        // Clase de fila por prioridad (para fondo suave)
        public string GetRowClass(int? prioridad)
        {
            int p = prioridad.GetValueOrDefault(1);
            if (p <= 2) return "row-pr-1";
            if (p <= 4) return "row-pr-3";
            return "row-pr-5";
        }

        // Guardar cambios desde el modal (síntomas y prioridad)
        protected void btnGuardarEdicion_Click(object sender, EventArgs e)
        {
            try
            {
                if (!int.TryParse(hfEditGuardiaId.Value, out var guardiaId) || guardiaId <= 0)
                    throw new Exception("Guardia inválida.");

                var sintomas = (txtEditSintomas.Text ?? "").Trim();

                int prioridad = 1;
                if (int.TryParse(hfEditPrioridad.Value, out var pr))
                    prioridad = Math.Max(1, Math.Min(5, pr));

                var repo = new Datos.Repositorios.GuardiaRepository();
                var g = repo.ObtenerPorId(guardiaId);
                if (g == null) throw new Exception("No se encontró la guardia.");

                g.Sintomas = sintomas;
                g.PrioridadFinal = prioridad;
                g.Estado = "Espera";

                repo.Actualizar(g);

                phMsg.Controls.Add(new Literal
                {
                    Text = "<div class='alert alert-success'>Cambios guardados correctamente.</div>"
                });

                Bind();
            }
            catch (Exception ex)
            {
                phMsg.Controls.Add(new Literal
                {
                    Text = $"<div class='alert alert-danger'>No se pudo guardar: {ex.Message}</div>"
                });
            }
        }
    }
}