using Datos.Repositorios;
using Entidades;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SistemaGuardiaClinica.Enfermeria
{
    public partial class TriageDetalle : Page
    {
        private int GuardiaId
        {
            get
            {
                int id;
                return int.TryParse(Request.QueryString["id"], out id) ? id : 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (GuardiaId <= 0)
                {
                    phMsg.Controls.Add(new Literal
                    {
                        Text = "<div class='alert alert-danger'>Guardia inválida.</div>"
                    });
                    pnlContenido.Visible = false;
                    return;
                }

                CargarEspecialidades();   // Carga lista de especialidades
                CargarEspecialistas();   // Llenamos el combo de médicos
                CargarDatos();          // Llenamos los datos de la guardia
                AplicarModoSoloLecturaSiCorresponde();
            }
        }

        private void CargarDatos()
        {
            var repo = new GuardiaRepository();
            var g = repo.ObtenerPorId(GuardiaId);

            if (g == null)
            {
                phMsg.Controls.Add(new Literal
                {
                    Text = "<div class='alert alert-danger'>No se encontró la guardia.</div>"
                });
                pnlContenido.Visible = false;
                return;
            }

            lblPaciente.Text = $"{g.Paciente?.Apellido}, {g.Paciente?.Nombre}";
            lblDni.Text = g.Paciente?.DNI;
            lblFechaIngreso.Text = g.FechaIngreso.ToString("dd/MM/yyyy HH:mm");

            if (g.Temperatura.HasValue)
                txtTemperatura.Text = g.Temperatura.Value.ToString("0.0", CultureInfo.InvariantCulture);

            if (g.FrecuenciaCardiaca.HasValue)
                txtFc.Text = g.FrecuenciaCardiaca.Value.ToString();

            if (g.FrecuenciaRespiratoria.HasValue)
                txtFr.Text = g.FrecuenciaRespiratoria.Value.ToString();

            if (g.PresionSistolica.HasValue)
                txtPaSistolica.Text = g.PresionSistolica.Value.ToString();

            if (g.PresionDiastolica.HasValue)
                txtPaDiastolica.Text = g.PresionDiastolica.Value.ToString();

            if (g.SaturacionOxigeno.HasValue)
                txtSpo2.Text = g.SaturacionOxigeno.Value.ToString();

            if (g.Glucemia.HasValue)
                txtGlucemia.Text = g.Glucemia.Value.ToString();

            if (g.Glasgow.HasValue)
                txtGlasgow.Text = g.Glasgow.Value.ToString();

            txtObsEnfermero.Text = g.ObservacionesEnfermero;

            if (!string.IsNullOrEmpty(g.NivelUrgenciaColor))
            {
                var item = rblNivelUrgencia.Items.FindByValue(g.NivelUrgenciaColor);
                if (item != null) item.Selected = true;
            }

            // Especialidad requerida
            if (!string.IsNullOrEmpty(g.EspecialidadRequerida))
            {
                var itemEsp = ddlEspecialidad.Items.FindByValue(g.EspecialidadRequerida);
                if (itemEsp != null)
                    itemEsp.Selected = true;

                // Cargamos especialistas filtrando por esa especialidad
                CargarEspecialistasPorEspecialidad(g.EspecialidadRequerida);
            }
            else
            {
                // Sin especialidad guardada → cargamos todos los médicos
                CargarEspecialistasPorEspecialidad(null);
            }

            // Si ya tiene médico asignado, lo seleccionamos en el combo
            if (g.MedicoId.HasValue)
            {
                var itemMed = ddlEspecialista.Items.FindByValue(g.MedicoId.Value.ToString());
                if (itemMed != null)
                    itemMed.Selected = true;
            }
        }

        private void CargarEspecialistas()
        {
            var repoUsuarios = new UsuarioRepository();
            var medicos = repoUsuarios.ObtenerMedicos();

            ddlEspecialista.Items.Clear();
            ddlEspecialista.Items.Add(new ListItem("-- Seleccionar especialista --", ""));

            foreach (var m in medicos)
            {
                // Armamos texto: "Apellido, Nombre - Especialidad"
                var texto = $"{m.Apellido}, {m.Nombre}";
                if (!string.IsNullOrEmpty(m.Especialidad))
                    texto += $" - {m.Especialidad}";

                ddlEspecialista.Items.Add(new ListItem(texto, m.Id.ToString()));
            }
        }

        private void GuardarCambiosEnEntidad(Guardia g)
        {
            decimal temp;
            int intVal;

            // Temperatura
            if (decimal.TryParse((txtTemperatura.Text ?? "").Replace(',', '.'), NumberStyles.Any, CultureInfo.InvariantCulture, out temp))
                g.Temperatura = temp;
            else
                g.Temperatura = null;

            // FC
            if (int.TryParse(txtFc.Text, out intVal))
                g.FrecuenciaCardiaca = intVal;
            else
                g.FrecuenciaCardiaca = null;

            // FR
            if (int.TryParse(txtFr.Text, out intVal))
                g.FrecuenciaRespiratoria = intVal;
            else
                g.FrecuenciaRespiratoria = null;

            // PA sistólica
            if (int.TryParse(txtPaSistolica.Text, out intVal))
                g.PresionSistolica = intVal;
            else
                g.PresionSistolica = null;

            // PA diastólica
            if (int.TryParse(txtPaDiastolica.Text, out intVal))
                g.PresionDiastolica = intVal;
            else
                g.PresionDiastolica = null;

            // SpO2
            if (int.TryParse(txtSpo2.Text, out intVal))
                g.SaturacionOxigeno = intVal;
            else
                g.SaturacionOxigeno = null;

            // Glucemia
            if (int.TryParse(txtGlucemia.Text, out intVal))
                g.Glucemia = intVal;
            else
                g.Glucemia = null;

            // Glasgow
            if (int.TryParse(txtGlasgow.Text, out intVal))
                g.Glasgow = intVal;
            else
                g.Glasgow = null;

            g.ObservacionesEnfermero = (txtObsEnfermero.Text ?? "").Trim();

            g.NivelUrgenciaColor = rblNivelUrgencia.SelectedValue;

            // Mapeo color → prioridad 1..5 (ajustalo si querés otro criterio)
            switch (g.NivelUrgenciaColor)
            {
                case "Rojo": g.PrioridadFinal = 1; break; // Emergencia – Inmediato
                case "Naranja": g.PrioridadFinal = 1; break; // Emergencia – Muy urgente
                case "Amarillo": g.PrioridadFinal = 2; break; // Urgente
                case "Verde": g.PrioridadFinal = 4; break; // Menos urgente
                case "Azul": g.PrioridadFinal = 5; break; // Leve / administrativa
                default:
                    // si no eligió color, no toco PrioridadFinal
                    break;
            }

            // Enfermero que hizo el triage (si lo tenés en sesión)
            if (Session["UsuarioId"] != null)
            {
                int enfermeroId;
                if (int.TryParse(Session["UsuarioId"].ToString(), out enfermeroId) && enfermeroId > 0)
                    g.EnfermeroId = enfermeroId;
            }

            g.EspecialidadRequerida = ddlEspecialidad.SelectedValue;

            int medicoId;
            if (int.TryParse(ddlEspecialista.SelectedValue, out medicoId) && medicoId > 0)
                g.MedicoId = medicoId;

        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                var repo = new GuardiaRepository();
                var g = repo.ObtenerPorId(GuardiaId);
                if (g == null) throw new Exception("No se encontró la guardia.");

                GuardarCambiosEnEntidad(g);

                // NO cambiar el estado acá
                // if (string.IsNullOrEmpty(g.Estado) || g.Estado == "Espera")
                //     g.Estado = "Triaje";

                repo.Actualizar(g);

                // Volver a la pantalla de lista
                Response.Redirect("~/Enfermeria/Triage.aspx", false);
            }
            catch (Exception ex)
            {
                phMsg.Controls.Add(new Literal
                {
                    Text = $"<div class='alert alert-danger'>No se pudo guardar: {ex.Message}</div>"
                });
            }
        }

        protected void btnEnviarEspecialista_Click(object sender, EventArgs e)
        {
            try
            {
                var repo = new Datos.Repositorios.GuardiaRepository();
                var g = repo.ObtenerPorId(GuardiaId);
                if (g == null) throw new Exception("No se encontró la guardia.");

                GuardarCambiosEnEntidad(g); // guarda signos + observaciones + color + especialidad

                int medicoId;
                if (int.TryParse(ddlEspecialista.SelectedValue, out medicoId) && medicoId > 0)
                {
                    g.MedicoId = medicoId;
                    g.Estado = "Atencion";   //Si sale de "Espera" y va a médicos
                }
                else
                {
                    throw new Exception("Seleccioná un especialista antes de enviar.");
                }

                repo.Actualizar(g);

                Response.Redirect("~/Enfermeria/Triage.aspx", false);
            }
            catch (Exception ex)
            {
                phMsg.Controls.Add(new Literal
                {
                    Text = $"<div class='alert alert-danger'>No se pudo enviar a especialista: {ex.Message}</div>"
                });
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Enfermeria/Triage.aspx", false);
        }

        private void AplicarModoSoloLecturaSiCorresponde()
        {
            var modo = (Request.QueryString["modo"] ?? "").ToLowerInvariant();
            if (modo != "info") return;

            // Deshabilitar inputs
            txtTemperatura.Enabled = false;
            txtFc.Enabled = false;
            txtFr.Enabled = false;
            txtPaSistolica.Enabled = false;
            txtPaDiastolica.Enabled = false;
            txtSpo2.Enabled = false;
            txtGlucemia.Enabled = false;
            txtGlasgow.Enabled = false;
            txtObsEnfermero.Enabled = false;
            rblNivelUrgencia.Enabled = false;

            btnGuardar.Visible = false;
            btnEnviarEspecialista.Visible = false;
            btnCancelar.Text = "Volver";
        }

        private void CargarEspecialidades()
        {
            var repoUsuarios = new UsuarioRepository();
            var especialidades = repoUsuarios.ObtenerEspecialidadesMedicas();

            ddlEspecialidad.Items.Clear();
            ddlEspecialidad.Items.Add(new ListItem("-- Seleccionar especialidad --", ""));

            foreach (var esp in especialidades)
            {
                ddlEspecialidad.Items.Add(new ListItem(esp, esp));
            }
        }

        private void CargarEspecialistasPorEspecialidad(string especialidad)
        {
            var repoUsuarios = new UsuarioRepository();
            List<Usuario> medicos;

            if (string.IsNullOrEmpty(especialidad))
                medicos = repoUsuarios.ObtenerMedicos();
            else
                medicos = repoUsuarios.ObtenerMedicosPorEspecialidad(especialidad);

            ddlEspecialista.Items.Clear();
            ddlEspecialista.Items.Add(new ListItem("-- Seleccionar especialista --", ""));

            foreach (var m in medicos)
            {
                var texto = string.Format("{0}, {1}", m.Apellido, m.Nombre);
                if (!string.IsNullOrEmpty(m.Especialidad))
                    texto += " - " + m.Especialidad;

                ddlEspecialista.Items.Add(new ListItem(texto, m.Id.ToString()));
            }
        }

        protected void ddlEspecialidad_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarEspecialistasPorEspecialidad(ddlEspecialidad.SelectedValue);
        }

    }
}