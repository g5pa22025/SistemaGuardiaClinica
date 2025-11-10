using Datos;
using Entidades;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.draw;
using System;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SistemaGuardiaClinica.Medicos
{
    public partial class HistoriaClinica : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // acá podrías validar rol médico usando Session["RolId"]
            if (!IsPostBack)
                CargarHistoria();
        }

        private int ObtenerPacienteIdDesdeQuery()
        {
            if (!int.TryParse(Request.QueryString["pacienteId"], out var pacienteId))
                return 0;
            return pacienteId;
        }

        private void CargarHistoria()
        {
            try
            {
                int pacienteId = ObtenerPacienteIdDesdeQuery();
                if (pacienteId <= 0)
                {
                    phMsg.Controls.Add(new Literal
                    {
                        Text = "<div class='alert alert-danger'>Paciente inválido.</div>"
                    });
                    return;
                }

                using (var ctx = new ClinicaContext())
                {
                    var paciente = ctx.Pacientes.FirstOrDefault(p => p.Id == pacienteId);
                    if (paciente == null)
                    {
                        phMsg.Controls.Add(new Literal
                        {
                            Text = "<div class='alert alert-danger'>Paciente no encontrado.</div>"
                        });
                        return;
                    }

                    lblPaciente.Text = $"{paciente.Apellido}, {paciente.Nombre}";
                    lblPacienteDatos.Text =
                        $"DNI: {paciente.DNI} · Fecha nac.: {paciente.FechaNacimiento:dd/MM/yyyy} · Obra social: {paciente.ObraSocial}";

                    var guardias = ctx.Guardias
                        .Where(g => g.PacienteId == pacienteId)
                        .OrderByDescending(g => g.FechaIngreso)
                        .ToList();

                    if (!guardias.Any())
                    {
                        phMsg.Controls.Add(new Literal
                        {
                            Text = "<div class='alert alert-info'>El paciente no tiene guardias registradas.</div>"
                        });
                    }

                    rpHistoria.DataSource = guardias;
                    rpHistoria.DataBind();
                }
            }
            catch (Exception ex)
            {
                phMsg.Controls.Add(new Literal
                {
                    Text = $"<div class='alert alert-danger'>Error al cargar la historia clínica: {ex.Message}</div>"
                });
            }
        }

        protected void btnDescargarPdf_Click(object sender, EventArgs e)
        {
            int pacienteId = ObtenerPacienteIdDesdeQuery();
            if (pacienteId <= 0) return;

            using (var ctx = new ClinicaContext())
            {
                var paciente = ctx.Pacientes.FirstOrDefault(p => p.Id == pacienteId);
                if (paciente == null) return;

                var guardias = ctx.Guardias
                    .Where(g => g.PacienteId == pacienteId)
                    .OrderBy(g => g.FechaIngreso)
                    .ToList();

                using (var ms = new MemoryStream())
                {
                    var doc = new Document(PageSize.A4, 36, 36, 36, 36);
                    PdfWriter.GetInstance(doc, ms);
                    doc.Open();

                    var titulo = new Paragraph(
                        $"Historia clínica - {paciente.Apellido}, {paciente.Nombre} (DNI {paciente.DNI})",
                        FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 14));
                    doc.Add(titulo);
                    doc.Add(new Paragraph(" "));
                    doc.Add(new Paragraph(
                        $"Fecha de nacimiento: {paciente.FechaNacimiento:dd/MM/yyyy}    Obra social: {paciente.ObraSocial}",
                        FontFactory.GetFont(FontFactory.HELVETICA, 10)));
                    doc.Add(new Paragraph(" "));
                    doc.Add(new LineSeparator());
                    doc.Add(new Paragraph(" "));

                    foreach (var g in guardias)
                    {
                        doc.Add(new Paragraph(
                            $"Ingreso: {g.FechaIngreso:dd/MM/yyyy HH:mm}  - Estado: {g.Estado}  - Prioridad: P{g.PrioridadFinal}",
                            FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10)));

                        doc.Add(new Paragraph(
                            $"Síntomas: {g.Sintomas}",
                            FontFactory.GetFont(FontFactory.HELVETICA, 10)));

                        doc.Add(new Paragraph(
                            $"Observaciones Enfermería: {g.ObservacionesEnfermero}",
                            FontFactory.GetFont(FontFactory.HELVETICA, 10)));

                        doc.Add(new Paragraph(
                            $"Especialidad requerida: {g.EspecialidadRequerida}",
                            FontFactory.GetFont(FontFactory.HELVETICA, 10)));

                        doc.Add(new Paragraph(
                            $"Diagnóstico médico: {g.DiagnosticoMedico}",
                            FontFactory.GetFont(FontFactory.HELVETICA, 10)));

                        doc.Add(new Paragraph(
                            $"Medicamentos: {g.Medicamentos}",
                            FontFactory.GetFont(FontFactory.HELVETICA, 10)));

                        doc.Add(new Paragraph(" "));
                        doc.Add(new LineSeparator());
                        doc.Add(new Paragraph(" "));
                    }

                    doc.Close();

                    var bytes = ms.ToArray();
                    Response.Clear();
                    Response.ContentType = "application/pdf";
                    Response.AddHeader("content-disposition", "attachment;filename=HistoriaClinica.pdf");
                    Response.BinaryWrite(bytes);
                    Response.End();
                }
            }
        }

        // Helpers para los badges usados en el .aspx
        public string GetBadge(int? prioridad)
        {
            int p = prioridad.GetValueOrDefault(1);
            string css;

            switch (p)
            {
                case 1: css = "bg-danger"; break;
                case 2: css = "bg-prio-orange"; break;
                case 3: css = "bg-warning"; break;
                case 4: css = "bg-success"; break;
                case 5: css = "bg-primary"; break;
                default: css = "bg-secondary"; break;
            }

            return $"<span class='badge {css} rounded-pill px-2 py-1'>P{p}</span>";
        }

        public string GetEstadoBadge(string estado)
        {
            estado = (estado ?? "").Trim();
            string css = "bg-secondary";
            string texto = estado;

            if (estado.Equals("Espera", StringComparison.OrdinalIgnoreCase))
            {
                css = "bg-warning";
                texto = "En espera";
            }
            else if (estado.Equals("Triaje", StringComparison.OrdinalIgnoreCase))
            {
                css = "bg-info";
                texto = "En triaje";
            }
            else if (estado.Equals("Atendido", StringComparison.OrdinalIgnoreCase))
            {
                css = "bg-success";
                texto = "Atendido";
            }

            return $"<span class='badge {css} rounded-pill px-2 py-1'>{texto}</span>";
        }
    }
}