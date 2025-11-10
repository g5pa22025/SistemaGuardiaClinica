using Datos;       // ClinicaContext
using Entidades;   // Paciente
using Negocio.Services;
using System;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Validation;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

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
                // Estados que consideramos "guardia activa"
                string[] activos = { "Espera", "Triaje", "Triaje" };

                // Query base: SOLO pacientes SIN guardia activa
                var q = ctx.Pacientes
                    .Where(p => !ctx.Guardias.Any(g => g.PacienteId == p.Id && activos.Contains(g.Estado)));

                // Filtros de búsqueda (DNI / Apellido)
                if (!string.IsNullOrEmpty(dni))
                    q = q.Where(p => p.DNI.Contains(dni));

                if (!string.IsNullOrEmpty(ape))
                    q = q.Where(p => p.Apellido.ToLower().Contains(ape));

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

                var fechaNac = ValidarFechaNacimiento(txtFechaNacimiento.Text);

                var nombre = (txtNombre.Text ?? "").Trim();
                var apellido = (txtApellido.Text ?? "").Trim();
                ValidarNombreApellido(nombre, apellido);

                var telefono = ValidarTelefono(txtTelefono.Text);
                var email = ValidarEmail(txtEmail.Text);
                var direccion = ValidarDireccion(txtDireccion.Text);
                var nroAfiliado = LimpiarAfiliado(txtNroAfiliado.Text);
                var obraSocial = ddlObraSocial.SelectedValue;
                if (string.IsNullOrWhiteSpace(obraSocial))
                    throw new Exception("El campo Obra Social / Prepaga es obligatorio.");

                var p = new Paciente
                {
                    DNI = (txtDni.Text ?? "").Trim(),
                    Nombre = nombre,
                    Apellido = apellido,
                    Telefono = telefono,
                    Email = email,
                    Direccion = direccion,
                    ObraSocial = obraSocial,
                    NumeroAfiliado = nroAfiliado,
                    Genero = ddlGenero.SelectedValue,
                    FechaNacimiento = fechaNac,
                    Prioridad = 5 // No urgente (Azul)
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

        //Validaciones

        private DateTime ValidarFechaNacimiento(string valor)
        {
            if (!DateTime.TryParse(valor, out var fecha))
                throw new Exception("Fecha de nacimiento inválida.");

            if (fecha > DateTime.Today)
                throw new Exception("La fecha de nacimiento no puede ser futura.");

            if (fecha < new DateTime(1900, 1, 1))
                throw new Exception("La fecha de nacimiento no puede ser anterior a 1900.");

            return fecha;
        }

        private void ValidarNombreApellido(string nombre, string apellido)
        {
            if (string.IsNullOrWhiteSpace(nombre) || nombre.Any(char.IsDigit))
                throw new Exception("Nombre inválido. No debe contener números.");

            if (string.IsNullOrWhiteSpace(apellido) || apellido.Any(char.IsDigit))
                throw new Exception("Apellido inválido. No debe contener números.");
        }

        private string ValidarTelefono(string tel)
        {
            tel = (tel ?? "").Trim();
            if (tel.Length == 0)
                throw new Exception("El campo Teléfono es obligatorio.");

            if (!tel.All(char.IsDigit))
                throw new Exception("El teléfono debe contener solo números.");

            if (tel.Length > 15)
                throw new Exception("El teléfono no puede superar los 15 dígitos.");

            return tel;
        }

        private string ValidarEmail(string email)
        {
            email = (email ?? "").Trim();
            if (email.Length == 0)
                throw new Exception("El campo Email es obligatorio.");

            if (email.Length > 40)
                throw new Exception("El email no puede superar los 40 caracteres.");

            return email;
        }

        private string ValidarDireccion(string dir)
        {
            dir = (dir ?? "").Trim();
            if (dir.Length == 0)
                throw new Exception("El campo Dirección es obligatorio.");

            if (dir.Length > 30)
                throw new Exception("La dirección no puede superar los 30 caracteres.");

            return dir;
        }

        private string LimpiarAfiliado(string nro)
        {
            nro = (nro ?? "").Trim();

            if (nro.Length == 0)
                throw new Exception("El campo Nro. Afiliado es obligatorio.");

            // Si viene "SIN COBERTURA" desde la UI, lo dejamos así
            if (string.Equals(nro, "SIN COBERTURA", StringComparison.OrdinalIgnoreCase))
                return "SIN COBERTURA";

            var soloAlfaNum = new string(nro.Where(char.IsLetterOrDigit).ToArray());
            if (soloAlfaNum.Length > 10)
                soloAlfaNum = soloAlfaNum.Substring(0, 10);

            return soloAlfaNum;
        }

        protected void cvFechaNac_ServerValidate(object source, ServerValidateEventArgs args)
        {
            try
            {
                ValidarFechaNacimiento(args.Value);
                args.IsValid = true;
            }
            catch
            {
                args.IsValid = false;
            }
        }

        protected void cvEditFechaNac_ServerValidate(object source, ServerValidateEventArgs args)
        {
            try
            {
                ValidarFechaNacimiento(args.Value);
                args.IsValid = true;
            }
            catch
            {
                args.IsValid = false;
            }
        }

        private void LimpiarModalAlta()
        {
            txtDni.Text = txtNombre.Text = txtApellido.Text = txtTelefono.Text = txtEmail.Text = "";
            ddlGenero.ClearSelection(); ddlGenero.Items[0].Selected = true;
            txtFechaNacimiento.Text = "";
        }

        // ================= EDICIÓN (modal) =================
        protected void btnGuardarEdicion_Click(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsValid)
                {
                    ShowMsg("Revisá los datos del paciente.", "warning");
                    return;
                }

                if (!int.TryParse(hfEditId.Value, out var id) || id <= 0)
                    throw new Exception("Id inválido.");

                var fechaNac = ValidarFechaNacimiento(txtEditFechaNac.Text);

                var nombre = (txtEditNombre.Text ?? "").Trim();
                var apellido = (txtEditApellido.Text ?? "").Trim();
                ValidarNombreApellido(nombre, apellido);

                var telefono = ValidarTelefono(txtEditTelefono.Text);
                var email = ValidarEmail(txtEditEmail.Text);
                var direccion = ValidarDireccion(txtEditDireccion.Text);
                var nroAfiliado = LimpiarAfiliado(txtEditNroAfiliado.Text);
                var obraSocial = ddlEditObraSocial.SelectedValue;
                if (string.IsNullOrWhiteSpace(obraSocial))
                    throw new Exception("El campo Obra Social / Prepaga es obligatorio.");

                using (var ctx = new ClinicaContext())
                {
                    var ent = ctx.Pacientes.FirstOrDefault(x => x.Id == id);
                    if (ent == null) throw new Exception("Paciente no encontrado.");

                    ent.Nombre = nombre;
                    ent.Apellido = apellido;
                    ent.Telefono = telefono;
                    ent.Email = email;
                    ent.ObraSocial = obraSocial;
                    ent.NumeroAfiliado = nroAfiliado;
                    ent.Genero = ddlEditGenero.SelectedValue;
                    ent.FechaNacimiento = fechaNac;
                    ent.Direccion = direccion;
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

        protected void btnConfirmarIngreso_Click(object sender, EventArgs e)
        {
            try
            {
                // 1) Leer pacienteId de forma segura
                if (!int.TryParse(hfIngresoPacienteId.Value, out var pacienteId) || pacienteId <= 0)
                    throw new Exception("PacienteId inválido.");

                // 2) Prioridad (si viene vacío, la pongo en 1)
                int prioridad = 1;
                if (int.TryParse(hfIngresoPrioridad.Value, out var pr))
                    prioridad = Math.Max(1, Math.Min(5, pr));

                var sintomas = (txtDescSintomas.Text ?? "").Trim();

                using (var ctx = new Datos.ClinicaContext())
                {
                    var paciente = ctx.Pacientes.FirstOrDefault(p => p.Id == pacienteId);
                    if (paciente == null) throw new Exception("Paciente no encontrado.");

                    // 3) Id del recepcionista desde sesión, SIN cast directo
                    int recepcionistaId = 0;

                    // Si guardaste el Id como número:
                    if (Session["UsuarioId"] != null)
                        recepcionistaId = Convert.ToInt32(Session["UsuarioId"]); // <-- evita InvalidCast

                    // Si guardaste el objeto completo:
                    if (recepcionistaId <= 0 && Session["Usuario"] is Entidades.Usuario u && u.Id > 0)
                        recepcionistaId = u.Id;

                    if (recepcionistaId <= 0) throw new Exception("Sesión inválida (no se encontró UsuarioId).");

                    // 4) Evitar duplicar guardia activa
                    var repo = new Datos.Repositorios.GuardiaRepository();
                    var existente = repo.ObtenerPorPaciente(pacienteId); // Espera/Triaje/Atencion
                    if (existente != null)
                    {
                        phMsg.Controls.Add(new Literal
                        {
                            Text = "<div class='alert alert-warning'>El paciente ya posee una guardia en curso.</div>"
                        });
                        return;
                    }

                    // 5) Crear guardia en Espera
                    var svc = new Negocio.Services.GuardiaService();
                    svc.IniciarGuardia(paciente, recepcionistaId, sintomas);

                    // 6) Setear prioridad calculada
                    var guardia = repo.ObtenerPorPaciente(pacienteId);
                    if (guardia != null)
                    {
                        guardia.PrioridadFinal = prioridad;
                        guardia.Estado = "Espera";
                        repo.Actualizar(guardia);
                    }
                }

                phMsg.Controls.Add(new Literal
                {
                    Text = "<div class='alert alert-success'>Ingreso registrado y derivado a Enfermería.</div>"
                });

                // Refrescar la grilla:
                BindGrid();
            }
            catch (Exception ex)
            {
                phMsg.Controls.Add(new Literal
                {
                    Text = $"<div class='alert alert-danger'>Error al registrar ingreso: {ex.Message}</div>"
                });
            }
        }

    }
}