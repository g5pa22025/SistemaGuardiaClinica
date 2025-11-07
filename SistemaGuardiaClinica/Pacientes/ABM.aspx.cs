using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Entity.Validation;
using System.Data.Entity.Infrastructure;
using System.Text;
using Datos;       // ClinicaContext
using Entidades;   // Paciente

namespace SistemaGuardiaClinica.Pacientes
{
    public partial class ABM : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Usuario"] == null)
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();

            if (!IsPostBack)
                BindGrid();
        }

        private void BindGrid()
        {
            var dni = (txtBuscarDni.Text ?? "").Trim();
            var ape = (txtBuscarApellido.Text ?? "").Trim().ToLower();

            using (var ctx = new ClinicaContext())
            {
                var q = ctx.Pacientes.AsQueryable();

                if (!string.IsNullOrEmpty(dni) || !string.IsNullOrEmpty(ape))
                {
                    q = q.Where(p =>
                        (!string.IsNullOrEmpty(dni) && p.DNI.Contains(dni)) ||
                        (!string.IsNullOrEmpty(ape) && p.Apellido.ToLower().Contains(ape))
                    );
                }

                gvPacientes.DataSource = q
                    .OrderBy(p => p.Apellido).ThenBy(p => p.Nombre)
                    .ToList();
                gvPacientes.DataBind();
            }
        }

        protected void btnBuscar_Click(object sender, EventArgs e) => BindGrid();

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtBuscarDni.Text = string.Empty;
            txtBuscarApellido.Text = string.Empty;
            BindGrid();
        }

        // ================= ALTA =================
        protected void btnGuardarAlta_Click(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsValid)
                {
                    ShowMsg("Revisá los campos obligatorios.", "warning");
                    return;
                }

                int prioridad;
                if (!int.TryParse(txtPrioridad.Text, out prioridad) || prioridad < 1 || prioridad > 5)
                    throw new Exception("La prioridad debe ser un número entre 1 y 5.");

                if (!DateTime.TryParse(txtFechaNacimiento.Text, out var fechaNac))
                    throw new Exception("Fecha de nacimiento inválida.");

                var p = new Paciente
                {
                    DNI = (txtDni.Text ?? "").Trim(),
                    Nombre = (txtNombre.Text ?? "").Trim(),
                    Apellido = (txtApellido.Text ?? "").Trim(),
                    Telefono = (txtTelefono.Text ?? "").Trim(),
                    Email = (txtEmail.Text ?? "").Trim(),
                    Direccion = (txtDireccion.Text ?? "").Trim(),
                    ObraSocial = (txtObraSocial.Text ?? "").Trim(),
                    NumeroAfiliado = (txtNroAfiliado.Text ?? "").Trim(),
                    Estado = (txtEstado.Text ?? "").Trim(),
                    Prioridad = prioridad,
                    Genero = ddlGenero.SelectedValue,
                    FechaNacimiento = fechaNac
                };

                using (var ctx = new ClinicaContext())
                {
                    ctx.Pacientes.Add(p);
                    ctx.SaveChanges();
                }

                ShowMsg("Paciente creado correctamente.", "success");
                LimpiarModalAlta();
                BindGrid();
            }
            catch (DbEntityValidationException vex)
            {
                ShowMsg("Validación de entidad fallida:\n" + FlattenEfValidation(vex), "danger");
            }
            catch (DbUpdateException duex)
            {
                ShowMsg("Error de base de datos:\n" + GetDeepMessage(duex), "danger");
            }
            catch (Exception ex)
            {
                ShowMsg("Error al crear paciente:\n" + GetDeepMessage(ex), "danger");
            }
        }

        private void LimpiarModalAlta()
        {
            txtDni.Text = txtNombre.Text = txtApellido.Text = txtTelefono.Text = txtEmail.Text =
            txtDireccion.Text = txtObraSocial.Text = txtNroAfiliado.Text = txtEstado.Text = txtPrioridad.Text = "";
            ddlGenero.ClearSelection(); ddlGenero.Items[0].Selected = true;
            txtFechaNacimiento.Text = "";
        }

        // ================= EDICIÓN (modal) =================
        protected void btnGuardarEdicion_Click(object sender, EventArgs e)
        {
            try
            {
                if (!int.TryParse(hfEditId.Value, out var id) || id <= 0)
                    throw new Exception("Id inválido.");

                if (!int.TryParse(txtEditPrioridad.Text, out var prioridad) || prioridad < 1 || prioridad > 5)
                    throw new Exception("La prioridad debe ser un número entre 1 y 5.");

                if (!DateTime.TryParse(txtEditFechaNac.Text, out var fechaNac))
                    throw new Exception("Fecha de nacimiento inválida.");

                using (var ctx = new ClinicaContext())
                {
                    var ent = ctx.Pacientes.FirstOrDefault(x => x.Id == id);
                    if (ent == null) throw new Exception("Paciente no encontrado.");

                    ent.Nombre = (txtEditNombre.Text ?? "").Trim();
                    ent.Apellido = (txtEditApellido.Text ?? "").Trim();
                    ent.Telefono = (txtEditTelefono.Text ?? "").Trim();
                    ent.Email = (txtEditEmail.Text ?? "").Trim();
                    ent.ObraSocial = (txtEditObraSocial.Text ?? "").Trim();
                    ent.NumeroAfiliado = (txtEditNroAfiliado.Text ?? "").Trim();
                    ent.Estado = (txtEditEstado.Text ?? "").Trim();
                    ent.Prioridad = prioridad;
                    ent.Genero = ddlEditGenero.SelectedValue;
                    ent.FechaNacimiento = fechaNac;
                    ent.Direccion = (txtEditDireccion.Text ?? "").Trim();
                    // DNI queda readonly (no se toca)

                    ctx.SaveChanges();
                }

                ShowMsg("Paciente actualizado correctamente.", "success");
                BindGrid();
            }
            catch (DbEntityValidationException vex)
            {
                ShowMsg("Validación de entidad fallida:\n" + FlattenEfValidation(vex), "danger");
            }
            catch (DbUpdateException duex)
            {
                ShowMsg("Error de base de datos:\n" + GetDeepMessage(duex), "danger");
            }
            catch (Exception ex)
            {
                ShowMsg("Error al actualizar:\n" + GetDeepMessage(ex), "danger");
            }
        }

        // ================= ELIMINACIÓN (confirm modal) =================
        protected void btnConfirmarDelete_Click(object sender, EventArgs e)
        {
            try
            {
                if (!int.TryParse(hfDeleteId.Value, out var id) || id <= 0)
                    throw new Exception("Id inválido.");

                using (var ctx = new ClinicaContext())
                {
                    var ent = ctx.Pacientes.FirstOrDefault(x => x.Id == id);
                    if (ent == null) throw new Exception("Paciente no encontrado.");
                    ctx.Pacientes.Remove(ent);
                    ctx.SaveChanges();
                }

                ShowMsg("Paciente eliminado.", "success");
                BindGrid();
            }
            catch (DbEntityValidationException vex)
            {
                ShowMsg("Validación de entidad fallida:\n" + FlattenEfValidation(vex), "danger");
            }
            catch (DbUpdateException duex)
            {
                ShowMsg("Error de base de datos:\n" + GetDeepMessage(duex), "danger");
            }
            catch (Exception ex)
            {
                ShowMsg("Error al eliminar:\n" + GetDeepMessage(ex), "danger");
            }
        }

        // ================= Helpers mensajes/errores =================
        private void ShowMsg(string text, string tipo = "info")
        {
            phMsg.Controls.Clear();
            var div = new System.Web.UI.HtmlControls.HtmlGenericControl("div");
            div.Attributes["class"] = $"alert alert-{tipo} mb-3";
            div.InnerText = text ?? string.Empty;
            phMsg.Controls.Add(div);
        }

        private string FlattenEfValidation(DbEntityValidationException ex)
        {
            var sb = new StringBuilder();
            foreach (var eve in ex.EntityValidationErrors)
            {
                var entity = eve.Entry.Entity?.GetType().Name ?? "Entidad";
                foreach (var ve in eve.ValidationErrors)
                    sb.AppendLine($"{entity}.{ve.PropertyName}: {ve.ErrorMessage}");
            }
            return sb.ToString();
        }

        private string GetDeepMessage(Exception ex)
        {
            var sb = new StringBuilder();
            while (ex != null)
            {
                sb.AppendLine(ex.Message);
                ex = ex.InnerException;
            }
            return sb.ToString();
        }
    }
}