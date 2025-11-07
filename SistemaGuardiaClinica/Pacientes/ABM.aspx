<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ABM.aspx.cs"
    Inherits="SistemaGuardiaClinica.Pacientes.ABM" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Gestión de Pacientes</title>
    <meta charset="utf-8" />
    <meta http-equiv="x-ua-compatible" content="ie=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!-- Bootstrap + Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

    <style>
        /* Toque visual propio :) */
        body { background: #f6f8fb; }
        .page-header { border-bottom: 1px solid #e9ecef; }
        .card { border-radius: 1rem; }
        .table thead th { white-space: nowrap; }
        .action-buttons .btn { min-width: 40px; }
        .modal .form-label { font-weight: 600; }
        .sticky-toolbar { position: sticky; top: 0; background: #f6f8fb; z-index: 2; padding-top: .5rem; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="container py-4">

        <div class="d-flex align-items-center justify-content-between mb-3 page-header">
            <div class="d-flex align-items-center gap-3">
            <button type="button" class="btn btn-outline-dark d-flex align-items-center"
            onclick="safeBack()">
            <i class="bi bi-arrow-left me-1"></i> Volver
            </button>
            <h3 class="mb-0 d-flex align-items-center">
                <i class="bi bi-people-fill me-2 text-primary"></i> Pacientes
            </h3>
        </div>
            <div class="d-flex align-items-center gap-2 sticky-toolbar">
                <asp:TextBox ID="txtBuscarDni" runat="server" CssClass="form-control" Placeholder="DNI" />
                <asp:TextBox ID="txtBuscarApellido" runat="server" CssClass="form-control" Placeholder="Apellido" />
                <asp:Button ID="btnBuscar" runat="server" CssClass="btn btn-outline-primary" Text="Buscar" OnClick="btnBuscar_Click" />
                <asp:Button ID="btnLimpiar" runat="server" CssClass="btn btn-outline-secondary" Text="Limpiar" OnClick="btnLimpiar_Click" />
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAlta">
                    <i class="bi bi-person-plus me-1"></i> Nuevo
                </button>
            </div>
        </div>

        <asp:PlaceHolder ID="phMsg" runat="server"></asp:PlaceHolder>

        <div class="card shadow-sm">
            <div class="card-body p-0">
                <asp:GridView ID="gvPacientes" runat="server"
                    CssClass="table table-hover table-striped mb-0 align-middle"
                    AutoGenerateColumns="False"
                    DataKeyNames="Id">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="true" />
                        <asp:BoundField DataField="DNI" HeaderText="DNI" ReadOnly="true" />
                        <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                        <asp:BoundField DataField="Apellido" HeaderText="Apellido" />
                        <asp:BoundField DataField="Genero" HeaderText="Género" />
                        <asp:BoundField DataField="Telefono" HeaderText="Teléfono" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="ObraSocial" HeaderText="Obra Social" />
                        <asp:BoundField DataField="NumeroAfiliado" HeaderText="Afiliado" />
                        <asp:BoundField DataField="Prioridad" HeaderText="Prioridad" />
                        <asp:BoundField DataField="Estado" HeaderText="Estado" />
                        <asp:TemplateField HeaderText="Fecha Nacimiento">
                            <ItemTemplate>
                                <%# Eval("FechaNacimiento", "{0:dd/MM/yyyy}") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Direccion" HeaderText="Dirección" />

                        <%-- Acciones lindas --%>
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <div class="d-flex gap-2 action-buttons">
                                    <button type="button" class="btn btn-sm btn-outline-warning"
                                        title="Editar"
                                        onclick='openEditModal(
                                            "<%# Eval("Id") %>",
                                            "<%# Eval("DNI") %>",
                                            "<%# Eval("Nombre").ToString().Replace("\"","\\\"") %>",
                                            "<%# Eval("Apellido").ToString().Replace("\"","\\\"") %>",
                                            "<%# Eval("Genero") %>",
                                            "<%# Eval("Telefono") %>",
                                            "<%# Eval("Email") %>",
                                            "<%# Eval("ObraSocial") %>",
                                            "<%# Eval("NumeroAfiliado") %>",
                                            "<%# Eval("Prioridad") %>",
                                            "<%# Eval("Estado").ToString().Replace("\"","\\\"") %>",
                                            "<%# ((DateTime)Eval("FechaNacimiento")).ToString("yyyy-MM-dd") %>"
                                            "<%# (Eval("Direccion") ?? "").ToString().Replace("\"","\\\"") %>" 
                                        )'> 
                                        <!-- 
                                            Uso (Eval("Campo") ?? "") para evitar null 
                                            Replace("\"","\\\"") evita romper la cadena JS si hay comillas en el texto.
                                        -->
                                        <i class="bi bi-pencil-square"></i>
                                    </button>

                                    <button type="button" class="btn btn-sm btn-outline-danger"
                                        title="Eliminar"
                                        onclick='openDeleteModal("<%# Eval("Id") %>", "<%# Eval("DNI") %>", "<%# (Eval("Apellido") + ", " + Eval("Nombre")).ToString().Replace("\"","\\\"") %>")'>
                                        <i class="bi bi-trash3"></i>
                                    </button>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <!-- Hidden fields para modales -->
    <asp:HiddenField ID="hfEditId" runat="server" />
    <asp:HiddenField ID="hfDeleteId" runat="server" />

    <!-- ================= MODAL ALTA ================= -->
    <div class="modal fade" id="modalAlta" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header bg-primary text-white">
            <h5 class="modal-title"><i class="bi bi-person-plus me-2"></i> Nuevo Paciente</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
          </div>
          <div class="modal-body">
            <div class="row g-3">

              <div class="col-md-3">
                <label class="form-label">DNI</label>
                <asp:TextBox ID="txtDni" runat="server" CssClass="form-control" MaxLength="12" />
                <asp:RequiredFieldValidator ControlToValidate="txtDni" runat="server" CssClass="text-danger" ErrorMessage="DNI obligatorio" Display="Dynamic" ValidationGroup="alta" />
              </div>

              <div class="col-md-3">
                <label class="form-label">Prioridad (1-5)</label>
                <asp:TextBox ID="txtPrioridad" runat="server" CssClass="form-control" TextMode="Number" />
                <asp:RequiredFieldValidator ControlToValidate="txtPrioridad" runat="server" CssClass="text-danger" ErrorMessage="Prioridad obligatoria" Display="Dynamic" ValidationGroup="alta" />
              </div>

              <div class="col-md-3">
                <label class="form-label">Estado</label>
                <asp:TextBox ID="txtEstado" runat="server" CssClass="form-control" />
              </div>

              <div class="col-md-3">
                <label class="form-label">Teléfono</label>
                <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" />
              </div>

              <div class="col-md-4">
                <label class="form-label">Nombre</label>
                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ControlToValidate="txtNombre" runat="server" CssClass="text-danger" ErrorMessage="Nombre obligatorio" Display="Dynamic" ValidationGroup="alta" />
              </div>

              <div class="col-md-4">
                <label class="form-label">Apellido</label>
                <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ControlToValidate="txtApellido" runat="server" CssClass="text-danger" ErrorMessage="Apellido obligatorio" Display="Dynamic" ValidationGroup="alta" />
              </div>

              <div class="col-md-4">
                <label class="form-label">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" />
              </div>

              <div class="col-md-3">
                <label class="form-label">Género</label>
                <asp:DropDownList ID="ddlGenero" runat="server" CssClass="form-select">
                  <asp:ListItem Value="" Selected="True">-- Seleccione --</asp:ListItem>
                  <asp:ListItem Value="Masculino">Masculino</asp:ListItem>
                  <asp:ListItem Value="Femenino">Femenino</asp:ListItem>
                  <asp:ListItem Value="Otro">Otro</asp:ListItem>
                  <asp:ListItem Value="No informa">No informa</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlGenero"
                    InitialValue="" CssClass="text-danger" Display="Dynamic"
                    ErrorMessage="Género obligatorio" ValidationGroup="alta" />
              </div>

              <div class="col-md-3">
                <label class="form-label">Fecha de Nacimiento</label>
                <asp:TextBox ID="txtFechaNacimiento" runat="server" CssClass="form-control" TextMode="Date" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFechaNacimiento"
                    CssClass="text-danger" Display="Dynamic"
                    ErrorMessage="Fecha de nacimiento obligatoria" ValidationGroup="alta" />
              </div>

              <div class="col-md-6">
                <label class="form-label">Dirección</label>
                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" />
              </div>

              <div class="col-md-3">
                <label class="form-label">Obra Social</label>
                <asp:TextBox ID="txtObraSocial" runat="server" CssClass="form-control" />
              </div>

              <div class="col-md-3">
                <label class="form-label">Nro. Afiliado</label>
                <asp:TextBox ID="txtNroAfiliado" runat="server" CssClass="form-control" />
              </div>

            </div>
          </div>
          <div class="modal-footer">
            <asp:Button ID="btnGuardarAlta" runat="server" CssClass="btn btn-primary" Text="Guardar" OnClick="btnGuardarAlta_Click" ValidationGroup="alta" />
            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
          </div>
        </div>
      </div>
    </div>

    <!-- ================= MODAL EDICIÓN ================= -->
    <div class="modal fade" id="modalEdit" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header bg-warning">
            <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i> Editar Paciente</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
          </div>
          <div class="modal-body">
            <div class="row g-3">

              <div class="col-md-3">
                <label class="form-label">DNI</label>
                <asp:TextBox ID="txtEditDni" runat="server" CssClass="form-control bg-light text-muted" ReadOnly="true" />
              </div>

              <div class="col-md-3">
                <label class="form-label">Prioridad (1-5)</label>
                <asp:TextBox ID="txtEditPrioridad" runat="server" CssClass="form-control" TextMode="Number" />
              </div>

              <div class="col-md-3">
                <label class="form-label">Estado</label>
                <asp:TextBox ID="txtEditEstado" runat="server" CssClass="form-control" />
              </div>

              <div class="col-md-3">
                <label class="form-label">Teléfono</label>
                <asp:TextBox ID="txtEditTelefono" runat="server" CssClass="form-control" />
              </div>

              <div class="col-md-4">
                <label class="form-label">Nombre</label>
                <asp:TextBox ID="txtEditNombre" runat="server" CssClass="form-control" />
              </div>

              <div class="col-md-4">
                <label class="form-label">Apellido</label>
                <asp:TextBox ID="txtEditApellido" runat="server" CssClass="form-control" />
              </div>

              <div class="col-md-4">
                <label class="form-label">Email</label>
                <asp:TextBox ID="txtEditEmail" runat="server" CssClass="form-control" TextMode="Email" />
              </div>

              <div class="col-md-3">
                <label class="form-label">Género</label>
                <asp:DropDownList ID="ddlEditGenero" runat="server" CssClass="form-select">
                  <asp:ListItem Value="Masculino">Masculino</asp:ListItem>
                  <asp:ListItem Value="Femenino">Femenino</asp:ListItem>
                  <asp:ListItem Value="Otro">Otro</asp:ListItem>
                  <asp:ListItem Value="No informa">No informa</asp:ListItem>
                </asp:DropDownList>
              </div>

              <div class="col-md-3">
                <label class="form-label">Fecha de Nacimiento</label>
                <asp:TextBox ID="txtEditFechaNac" runat="server" CssClass="form-control" TextMode="Date" />
              </div>

              <div class="col-md-6">
                <label class="form-label">Dirección</label>
                <asp:TextBox ID="txtEditDireccion" runat="server" CssClass="form-control" />
              </div>

              <div class="col-md-3">
                <label class="form-label">Obra Social</label>
                <asp:TextBox ID="txtEditObraSocial" runat="server" CssClass="form-control" />
              </div>

              <div class="col-md-3">
                <label class="form-label">Nro. Afiliado</label>
                <asp:TextBox ID="txtEditNroAfiliado" runat="server" CssClass="form-control" />
              </div>

            </div>
          </div>
          <div class="modal-footer">
            <asp:Button ID="btnGuardarEdicion" runat="server" CssClass="btn btn-warning" Text="Guardar cambios" OnClick="btnGuardarEdicion_Click" />
            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
          </div>
        </div>
      </div>
    </div>

    <!-- ================= MODAL ELIMINAR ================= -->
    <div class="modal fade" id="modalDelete" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header bg-danger text-white">
            <h5 class="modal-title"><i class="bi bi-exclamation-triangle me-2"></i> Confirmar eliminación</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
          </div>
          <div class="modal-body">
            <p>¿Seguro que querés eliminar al paciente?</p>
            <ul class="mb-0">
              <li><strong>Id:</strong> <span id="delId"></span></li>
              <li><strong>DNI:</strong> <span id="delDni"></span></li>
              <li><strong>Nombre:</strong> <span id="delNombre"></span></li>
            </ul>
          </div>
          <div class="modal-footer">
            <asp:Button ID="btnConfirmarDelete" runat="server" CssClass="btn btn-danger" Text="Eliminar" OnClick="btnConfirmarDelete_Click" />
            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
      // Helpers para abrir modales con datos
        function openEditModal(id, dni, nombre, apellido, genero, telefono, email, obra, afiliado, prioridad, estado, fechaNac, Direccion) {

            Direccion = (typeof Direccion === "undefined" || Direccion === null) ? "" : Direccion;

        document.getElementById("<%= hfEditId.ClientID %>").value = id;
        document.getElementById("<%= txtEditDni.ClientID %>").value = dni;
        document.getElementById("<%= txtEditNombre.ClientID %>").value = nombre;
        document.getElementById("<%= txtEditApellido.ClientID %>").value = apellido;
        document.getElementById("<%= ddlEditGenero.ClientID %>").value = genero;
        document.getElementById("<%= txtEditTelefono.ClientID %>").value = telefono;
        document.getElementById("<%= txtEditEmail.ClientID %>").value = email;
        document.getElementById("<%= txtEditObraSocial.ClientID %>").value = obra;
        document.getElementById("<%= txtEditNroAfiliado.ClientID %>").value = afiliado;
        document.getElementById("<%= txtEditPrioridad.ClientID %>").value = prioridad;
        document.getElementById("<%= txtEditEstado.ClientID %>").value = estado;
        document.getElementById("<%= txtEditFechaNac.ClientID %>").value = fechaNac;
        document.getElementById("<%= txtEditDireccion.ClientID %>").value = Direccion; 

        var modal = new bootstrap.Modal(document.getElementById('modalEdit'));
        modal.show();
      }

      function openDeleteModal(id, dni, nombreCompleto) {
        document.getElementById("<%= hfDeleteId.ClientID %>").value = id;
        document.getElementById("delId").innerText = id;
        document.getElementById("delDni").innerText = dni;
        document.getElementById("delNombre").innerText = nombreCompleto;
        var modal = new bootstrap.Modal(document.getElementById('modalDelete'));
        modal.show();
      }
    </script>
</form>
</body>
</html>