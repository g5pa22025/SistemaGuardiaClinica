using System;
using System.Linq;
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
            // Cabecera: nombre del usuario (si lo tenés en sesión)
            if (Session["UsuarioNombre"] != null || Session["Usuario"] is Usuario)
            {
                var nombre = Session["UsuarioNombre"] as string;
                var apellido = Session["UsuarioApellido"] as string;
                if (string.IsNullOrWhiteSpace(nombre) && Session["Usuario"] is Usuario u)
                {
                    nombre = u.Nombre; apellido = u.Apellido;
                }
                litUsuario.Text = $"{apellido}, {nombre}".Trim(new[] { ' ', ',' });
            }
            else
            {
                litUsuario.Text = "Usuario";
            }

            if (!IsPostBack)
                Bind();
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

                // leemos valores desde los controles
                var sintomas = (txtEditSintomas.Text ?? "").Trim();

                int prioridad = 1;
                if (int.TryParse(hfEditPrioridad.Value, out var pr))
                    prioridad = Math.Max(1, Math.Min(5, pr));

                // actualizar en BD
                var repo = new Datos.Repositorios.GuardiaRepository();
                var g = repo.ObtenerPorId(guardiaId);
                if (g == null) throw new Exception("No se encontró la guardia.");

                // si el enfermero dice que no cambió, igual podemos reconfirmar
                g.Sintomas = sintomas;            // actualiza si cambió el texto
                g.PrioridadFinal = prioridad;     // confirmar o ajustar
                g.Estado = "Espera";              // sigue listado en espera hasta que abra TriageDetalle

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