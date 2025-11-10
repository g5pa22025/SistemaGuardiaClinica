<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ABM.aspx.cs"
    Inherits="SistemaGuardiaClinica.Pacientes.ABM"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Bootstrap Icons (el master ya tiene Bootstrap y FontAwesome) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <style>
        body {
            background: #f6f8fb;
        }

        .page-header {
            border-bottom: 1px solid #e9ecef;
        }

        .card {
            border-radius: 1rem;
        }

        .table thead th {
            white-space: nowrap;
        }

        .action-buttons .btn {
            min-width: 40px;
        }

        .modal .form-label {
            font-weight: 600;
        }

        .sticky-toolbar {
            position: sticky;
            top: 0;
            background: #f6f8fb;
            z-index: 2;
            padding-top: .5rem;
        }

        .bg-orange {
            background-color: #fd7e14 !important;
        }

        .required-star {
            color: #dc3545; /* rojo bootstrap */
            margin-left: 2px;
        }
    </style>

    <div class="container py-4">

        <div class="d-flex align-items-center justify-content-between mb-3 page-header">
            <div class="d-flex align-items-center gap-3">
                <button type="button" class="btn btn-outline-dark d-flex align-items-center"
                    onclick="safeBack()">
                    <i class="bi bi-arrow-left me-1"></i>Volver
                </button>
                <h3 class="mb-0 d-flex align-items-center">
                    <i class="bi bi-people-fill me-2 text-primary"></i>Pacientes
                </h3>
            </div>
            <div class="d-flex align-items-center gap-2 sticky-toolbar">
                <asp:TextBox ID="txtBuscarDni" runat="server" CssClass="form-control" Placeholder="DNI" />
                <asp:TextBox ID="txtBuscarApellido" runat="server" CssClass="form-control" Placeholder="Apellido" />
                <asp:Button ID="btnBuscar" runat="server" CssClass="btn btn-outline-primary" Text="Buscar" OnClick="btnBuscar_Click" />
                <asp:Button ID="btnLimpiar" runat="server" CssClass="btn btn-outline-secondary" Text="Limpiar" OnClick="btnLimpiar_Click" />
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAlta">
                    <i class="bi bi-person-plus me-1"></i>Nuevo
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
                        <asp:BoundField DataField="DNI" HeaderText="DNI" ReadOnly="true" />
                        <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                        <asp:BoundField DataField="Apellido" HeaderText="Apellido" />
                        <asp:BoundField DataField="Genero" HeaderText="Género" />
                        <asp:BoundField DataField="Telefono" HeaderText="Teléfono" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="ObraSocial" HeaderText="Obra Social" />
                        <asp:BoundField DataField="NumeroAfiliado" HeaderText="Afiliado" />

                        <asp:TemplateField HeaderText="Fecha Nacimiento">
                            <ItemTemplate>
                                <%# Eval("FechaNacimiento", "{0:dd/MM/yyyy}") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Direccion" HeaderText="Dirección" />

                        <%-- Acciones --%>
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <div class="d-flex gap-2 action-buttons">

                                    <!-- Registrar ingreso (abre modal) -->
                                    <button type="button"
                                        class="btn btn-success btn-sm d-flex align-items-center"
                                        title="Registrar ingreso del paciente a la guardia"
                                        onclick='openIngresoModal(
                                                "<%# Eval("Id") %>",
                                                "<%# (Eval("Apellido") + ", " + Eval("Nombre")).ToString().Replace("\"","\\\"") %>",
                                                "<%# Eval("DNI") %>"
                                            )'>
                                        <i class="bi bi-clipboard-plus me-1"></i>Registrar Ingreso
                                    </button>

                                    <!-- Editar -->
                                    <button type="button" class="btn btn-sm btn-outline-warning"
                                        title="Editar paciente"
                                        onclick='openEditModal(
                                                "<%# Eval("Id") %>",
                                                "<%# HttpUtility.JavaScriptStringEncode(Convert.ToString(Eval("DNI")) ?? "") %>",
                                                "<%# HttpUtility.JavaScriptStringEncode(Convert.ToString(Eval("Nombre")) ?? "") %>",
                                                "<%# HttpUtility.JavaScriptStringEncode(Convert.ToString(Eval("Apellido")) ?? "") %>",
                                                "<%# HttpUtility.JavaScriptStringEncode(Convert.ToString(Eval("Genero")) ?? "") %>",
                                                "<%# HttpUtility.JavaScriptStringEncode(Convert.ToString(Eval("Telefono")) ?? "") %>",
                                                "<%# HttpUtility.JavaScriptStringEncode(Convert.ToString(Eval("Email")) ?? "") %>",
                                                "<%# HttpUtility.JavaScriptStringEncode(Convert.ToString(Eval("ObraSocial")) ?? "") %>",
                                                "<%# HttpUtility.JavaScriptStringEncode(Convert.ToString(Eval("NumeroAfiliado")) ?? "") %>",
                                                "<%# (Eval("FechaNacimiento") == null ? "" : ((DateTime)Eval("FechaNacimiento")).ToString("yyyy-MM-dd")) %>",
                                                "<%# HttpUtility.JavaScriptStringEncode(Convert.ToString(Eval("Direccion")) ?? "") %>"
                                            )'>
                                        <i class="bi bi-pencil-square"></i>
                                    </button>

                                    <!-- Eliminar -->
                                    <button type="button" class="btn btn-sm btn-outline-danger"
                                        title="Eliminar paciente"
                                        onclick='openDeleteModal(
                                                "<%# Eval("Id") %>", 
                                                "<%# Eval("DNI") %>", 
                                                "<%# (Eval("Apellido") + ", " + Eval("Nombre")).ToString().Replace("\"","\\\"") %>"
                                            )'>
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
    <asp:HiddenField ID="hfIngresoPacienteId" runat="server" />
    <asp:HiddenField ID="hfIngresoPrioridad" runat="server" />

    <!-- ================= MODAL ALTA ================= -->
    <div class="modal fade" id="modalAlta" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">
                        <i class="bi bi-person-plus me-2"></i>Nuevo Paciente
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body">
                    <div class="row g-3">

                        <!-- IDENTIFICACIÓN -->
                        <div class="col-12">
                            <h6 class="text-uppercase text-muted mb-2">Identificación</h6>
                            <hr class="mt-0 mb-3" />
                        </div>

                        <div class="col-md-3">
                            <div class="form-floating">
                                <asp:TextBox ID="txtDni" runat="server" CssClass="form-control"
                                    MaxLength="8" placeholder="DNI"
                                    onkeypress="return soloNumeros(event)"
                                    oninput="this.value=this.value.replace(/[^0-9]/g,'');" />
                                <label for="txtDni">
                                    DNI <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator ControlToValidate="txtDni" runat="server"
                                CssClass="text-danger" ErrorMessage="El campo DNI es obligatorio."
                                Display="Dynamic" ValidationGroup="alta" />
                        </div>

                        <div class="col-md-4">
                            <div class="form-floating">
                                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control"
                                    placeholder="Nombre" MaxLength="50" />
                                <label for="txtNombre">
                                    Nombre <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator ControlToValidate="txtNombre" runat="server"
                                CssClass="text-danger"
                                ErrorMessage="El campo Nombre es obligatorio."
                                Display="Dynamic" ValidationGroup="alta" />
                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtNombre"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="alta"
                                ErrorMessage="El nombre no puede contener números."
                                ValidationExpression="^([A-Za-zÁÉÍÓÚÜÑáéíóúüñ ]+)$" />
                        </div>

                        <div class="col-md-5">
                            <div class="form-floating">
                                <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control"
                                    placeholder="Apellido" MaxLength="50" />
                                <label for="txtApellido">
                                    Apellido <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator ControlToValidate="txtApellido" runat="server"
                                CssClass="text-danger"
                                ErrorMessage="El campo Apellido es obligatorio."
                                Display="Dynamic" ValidationGroup="alta" />
                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtApellido"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="alta"
                                ErrorMessage="El apellido no puede contener números."
                                ValidationExpression="^([A-Za-zÁÉÍÓÚÜÑáéíóúüñ ]+)$" />
                        </div>

                        <div class="col-md-4">
                            <div class="form-floating">
                                <asp:DropDownList ID="ddlGenero" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="" Selected="True">-- Seleccione --</asp:ListItem>
                                    <asp:ListItem Value="Masculino">Masculino</asp:ListItem>
                                    <asp:ListItem Value="Femenino">Femenino</asp:ListItem>
                                    <asp:ListItem Value="Otro">Otro</asp:ListItem>
                                    <asp:ListItem Value="No informa">No informa</asp:ListItem>
                                </asp:DropDownList>
                                <label for="ddlGenero">
                                    Género <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlGenero"
                                InitialValue=""
                                CssClass="text-danger" Display="Dynamic"
                                ErrorMessage="El campo Género es obligatorio."
                                ValidationGroup="alta" />
                        </div>

                        <div class="col-md-4">
                            <div class="form-floating">
                                <asp:TextBox ID="txtFechaNacimiento" runat="server"
                                    CssClass="form-control" TextMode="Date" />
                                <label for="txtFechaNacimiento">
                                    Fecha de Nacimiento <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFechaNacimiento"
                                CssClass="text-danger" Display="Dynamic"
                                ErrorMessage="El campo Fecha de nacimiento es obligatorio."
                                ValidationGroup="alta" />
                            <asp:CustomValidator ID="cvFechaNac" runat="server"
                                ControlToValidate="txtFechaNacimiento"
                                CssClass="text-danger" Display="Dynamic"
                                ErrorMessage="La fecha debe estar entre 01/01/1900 y hoy."
                                ValidationGroup="alta"
                                OnServerValidate="cvFechaNac_ServerValidate" />
                        </div>


                        <!-- CONTACTO -->
                        <div class="col-12 mt-2">
                            <h6 class="text-uppercase text-muted mb-2">Contacto</h6>
                            <hr class="mt-0 mb-3" />
                        </div>

                        <div class="col-md-4">
                            <div class="form-floating">
                                <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control"
                                    placeholder="Teléfono" MaxLength="15"
                                    oninput="this.value=this.value.replace(/[^0-9]/g,'');" />
                                <label for="txtTelefono">
                                    Teléfono <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtTelefono"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="alta"
                                ErrorMessage="El campo Teléfono es obligatorio." />
                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtTelefono"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="alta"
                                ErrorMessage="El teléfono debe tener hasta 15 dígitos numéricos."
                                ValidationExpression="^[0-9]{1,15}$" />
                        </div>


                        <div class="col-md-8">
                            <div class="form-floating">
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                                    TextMode="Email" placeholder="Email" MaxLength="40" />
                                <label for="txtEmail">
                                    Email <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtEmail"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="alta"
                                ErrorMessage="El campo Email es obligatorio." />
                        </div>


                        <div class="col-12">
                            <div class="form-floating">
                                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control"
                                    placeholder="Dirección" MaxLength="30" />
                                <label for="txtDireccion">
                                    Dirección <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtDireccion"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="alta"
                                ErrorMessage="El campo Dirección es obligatorio." />
                        </div>


                        <!-- COBERTURA -->
                        <div class="col-12 mt-2">
                            <h6 class="text-uppercase text-muted mb-2">Cobertura</h6>
                            <hr class="mt-0 mb-3" />
                        </div>

                        <div class="col-md-6">
                            <div class="form-floating">
                                <asp:DropDownList ID="ddlObraSocial" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="">-- Seleccione --</asp:ListItem>
                                    <asp:ListItem>OSDE</asp:ListItem>
                                    <asp:ListItem>Swiss Medical</asp:ListItem>
                                    <asp:ListItem>Galeno</asp:ListItem>
                                    <asp:ListItem>Medicus</asp:ListItem>
                                    <asp:ListItem>Omint</asp:ListItem>
                                    <asp:ListItem>Medifé</asp:ListItem>
                                    <asp:ListItem>OSECAC</asp:ListItem>
                                    <asp:ListItem>PAMI</asp:ListItem>
                                    <asp:ListItem>Unión Personal</asp:ListItem>
                                    <asp:ListItem>IOMA</asp:ListItem>
                                    <asp:ListItem>UOM</asp:ListItem>
                                    <asp:ListItem>OSUTHGRA (Gastronómicos)</asp:ListItem>
                                    <asp:ListItem>OSCHOCA (Camioneros)</asp:ListItem>
                                    <asp:ListItem>OSPRERA (Personal Rural)</asp:ListItem>
                                    <asp:ListItem>OSPSA (Sanidad)</asp:ListItem>
                                    <asp:ListItem>OSPECON (Construcción)</asp:ListItem>
                                    <asp:ListItem>OSPE (Petroleros)</asp:ListItem>
                                    <asp:ListItem>ObSBA (Obra Social de Buenos Aires)</asp:ListItem>
                                    <asp:ListItem>Otros</asp:ListItem>
                                    <asp:ListItem>SIN COBERTURA</asp:ListItem>
                                </asp:DropDownList>
                                <label for="ddlObraSocial">
                                    Obra Social / Prepaga <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="ddlObraSocial"
                                InitialValue=""
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="alta"
                                ErrorMessage="El campo Obra Social / Prepaga es obligatorio." />
                        </div>

                        <div class="col-md-6">
                            <div class="form-floating">
                                <asp:TextBox ID="txtNroAfiliado" runat="server" CssClass="form-control"
                                    placeholder="Nro. Afiliado" MaxLength="10"
                                    oninput="limpiarAfiliado(this)" />
                                <label for="txtNroAfiliado">
                                    Nro. Afiliado <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtNroAfiliado"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="alta"
                                ErrorMessage="El campo Nro. Afiliado es obligatorio." />
                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtNroAfiliado"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="alta"
                                ErrorMessage="Máximo 10 caracteres alfanuméricos (o SIN COBERTURA)."
                                ValidationExpression="^(SIN COBERTURA|[A-Za-z0-9]{1,10})$" />

                        </div>


                    </div>
                </div>

                <div class="modal-footer flex-column flex-sm-row gap-2">
                    <asp:Button ID="btnGuardarAlta" runat="server" CssClass="btn btn-primary px-4" Text="Guardar"
                        OnClick="btnGuardarAlta_Click" ValidationGroup="alta" />
                    <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Cancelar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ================= MODAL EDICIÓN ================= -->
    <div class="modal fade" id="modalEdit" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header bg-warning">
                    <h5 class="modal-title">
                        <i class="bi bi-pencil-square me-2"></i>Editar Paciente
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body">
                    <div class="row g-3">

                        <div class="col-12">
                            <h6 class="text-uppercase text-muted mb-2">Identificación</h6>
                            <hr class="mt-0 mb-3" />
                        </div>

                        <div class="col-md-3">
                            <div class="form-floating">
                                <asp:TextBox ID="txtEditDni" runat="server" CssClass="form-control bg-light text-muted"
                                    ReadOnly="true" placeholder="DNI" />
                                <label for="txtEditDni">DNI</label>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-floating">
                                <asp:TextBox ID="txtEditNombre" runat="server" CssClass="form-control"
                                    placeholder="Nombre" MaxLength="50" />
                                <label for="txtEditNombre">
                                    Nombre <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator ControlToValidate="txtEditNombre" runat="server"
                                CssClass="text-danger"
                                ErrorMessage="El campo Nombre es obligatorio."
                                Display="Dynamic" ValidationGroup="edit" />
                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtEditNombre"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="edit"
                                ErrorMessage="El nombre no puede contener números."
                                ValidationExpression="^([A-Za-zÁÉÍÓÚÜÑáéíóúüñ ]+)$" />
                        </div>

                        <div class="col-md-5">
                            <div class="form-floating">
                                <asp:TextBox ID="txtEditApellido" runat="server" CssClass="form-control"
                                    placeholder="Apellido" MaxLength="50" />
                                <label for="txtEditApellido">
                                    Apellido <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator ControlToValidate="txtEditApellido" runat="server"
                                CssClass="text-danger"
                                ErrorMessage="El campo Apellido es obligatorio."
                                Display="Dynamic" ValidationGroup="edit" />
                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtEditApellido"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="edit"
                                ErrorMessage="El apellido no puede contener números."
                                ValidationExpression="^([A-Za-zÁÉÍÓÚÜÑáéíóúüñ ]+)$" />
                        </div>

                        <div class="col-md-4">
                            <div class="form-floating">
                                <asp:DropDownList ID="ddlEditGenero" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="" Selected="True">-- Seleccione --</asp:ListItem>
                                    <asp:ListItem Value="Masculino">Masculino</asp:ListItem>
                                    <asp:ListItem Value="Femenino">Femenino</asp:ListItem>
                                    <asp:ListItem Value="Otro">Otro</asp:ListItem>
                                    <asp:ListItem Value="No informa">No informa</asp:ListItem>
                                </asp:DropDownList>
                                <label for="ddlEditGenero">
                                    Género <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlEditGenero"
                                InitialValue=""
                                CssClass="text-danger" Display="Dynamic"
                                ErrorMessage="El campo Género es obligatorio."
                                ValidationGroup="edit" />
                        </div>

                        <div class="col-md-4">
                            <div class="form-floating">
                                <asp:TextBox ID="txtEditFechaNac" runat="server" CssClass="form-control"
                                    TextMode="Date" />
                                <label for="txtEditFechaNac">
                                    Fecha de Nacimiento <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtEditFechaNac"
                                CssClass="text-danger" Display="Dynamic"
                                ErrorMessage="El campo Fecha de nacimiento es obligatorio."
                                ValidationGroup="edit" />
                            <asp:CustomValidator ID="cvEditFechaNac" runat="server"
                                ControlToValidate="txtEditFechaNac"
                                CssClass="text-danger" Display="Dynamic"
                                ErrorMessage="La fecha debe estar entre 01/01/1900 y hoy."
                                ValidationGroup="edit"
                                OnServerValidate="cvEditFechaNac_ServerValidate" />
                        </div>



                        <div class="col-12 mt-2">
                            <h6 class="text-uppercase text-muted mb-2">Contacto</h6>
                            <hr class="mt-0 mb-3" />
                        </div>

                        <div class="col-md-4">
                            <div class="form-floating">
                                <asp:TextBox ID="txtEditTelefono" runat="server" CssClass="form-control"
                                    placeholder="Teléfono" MaxLength="15"
                                    oninput="this.value=this.value.replace(/[^0-9]/g,'');" />
                                <label for="txtEditTelefono">
                                    Teléfono <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtEditTelefono"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="edit"
                                ErrorMessage="El campo Teléfono es obligatorio." />
                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtEditTelefono"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="edit"
                                ErrorMessage="El teléfono debe tener hasta 15 dígitos numéricos."
                                ValidationExpression="^[0-9]{1,15}$" />
                        </div>

                        <div class="col-md-8">
                            <div class="form-floating">
                                <asp:TextBox ID="txtEditEmail" runat="server" CssClass="form-control"
                                    TextMode="Email" placeholder="Email" MaxLength="40" />
                                <label for="txtEditEmail">
                                    Email <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtEditEmail"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="edit"
                                ErrorMessage="El campo Email es obligatorio." />
                        </div>
                        <div class="col-12">
                            <div class="form-floating">
                                <asp:TextBox ID="txtEditDireccion" runat="server" CssClass="form-control"
                                    placeholder="Dirección" MaxLength="30" />
                                <label for="txtEditDireccion">
                                    Dirección <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtEditDireccion"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="edit"
                                ErrorMessage="El campo Dirección es obligatorio." />
                        </div>

                        <div class="col-12 mt-2">
                            <h6 class="text-uppercase text-muted mb-2">Cobertura</h6>
                            <hr class="mt-0 mb-3" />
                        </div>

                        <div class="col-md-6">
                            <div class="form-floating">
                                <asp:DropDownList ID="ddlEditObraSocial" runat="server" CssClass="form-select">
                                    <asp:ListItem>OSDE</asp:ListItem>
                                    <asp:ListItem>Swiss Medical</asp:ListItem>
                                    <asp:ListItem>Galeno</asp:ListItem>
                                    <asp:ListItem>Medicus</asp:ListItem>
                                    <asp:ListItem>Omint</asp:ListItem>
                                    <asp:ListItem>Medifé</asp:ListItem>
                                    <asp:ListItem>OSECAC</asp:ListItem>
                                    <asp:ListItem>PAMI</asp:ListItem>
                                    <asp:ListItem>Unión Personal</asp:ListItem>
                                    <asp:ListItem>IOMA</asp:ListItem>
                                    <asp:ListItem>UOM</asp:ListItem>
                                    <asp:ListItem>OSUTHGRA (Gastronómicos)</asp:ListItem>
                                    <asp:ListItem>OSCHOCA (Camioneros)</asp:ListItem>
                                    <asp:ListItem>OSPRERA (Personal Rural)</asp:ListItem>
                                    <asp:ListItem>OSPSA (Sanidad)</asp:ListItem>
                                    <asp:ListItem>OSPECON (Construcción)</asp:ListItem>
                                    <asp:ListItem>OSPE (Petroleros)</asp:ListItem>
                                    <asp:ListItem>ObSBA (Obra Social de Buenos Aires)</asp:ListItem>
                                    <asp:ListItem>Otros</asp:ListItem>
                                    <asp:ListItem>SIN COBERTURA</asp:ListItem>
                                </asp:DropDownList>
                                <label for="ddlEditObraSocial">
                                    Obra Social / Prepaga <span class="required-star">*</span>
                                </label>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-floating">
                                <asp:TextBox ID="txtEditNroAfiliado" runat="server" CssClass="form-control"
                                    placeholder="Nro. Afiliado" MaxLength="10"
                                    oninput="limpiarAfiliado(this)" />
                                <label for="txtEditNroAfiliado">
                                    Nro. Afiliado <span class="required-star">*</span>
                                </label>
                            </div>
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtEditNroAfiliado"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="edit"
                                ErrorMessage="El campo Nro. Afiliado es obligatorio." />
                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtEditNroAfiliado"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="edit"
                                ErrorMessage="Máximo 10 caracteres alfanuméricos (o SIN COBERTURA)."
                                ValidationExpression="^(SIN COBERTURA|[A-Za-z0-9]{1,10})$" />

                        </div>



                    </div>
                </div>

                <div class="modal-footer flex-column flex-sm-row gap-2">
                    <asp:Button ID="btnGuardarEdicion" runat="server"
                        CssClass="btn btn-warning px-4" Text="Guardar cambios"
                        OnClick="btnGuardarEdicion_Click" ValidationGroup="edit" />

                    <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Cancelar</button>
                </div>
            </div>
        </div>
    </div>


    <!-- ================= MODAL ELIMINAR ================= -->
    <div class="modal fade" id="modalDelete" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title"><i class="bi bi-exclamation-triangle me-2"></i>Confirmar eliminación</h5>
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

    <!-- ============== MODAL REGISTRAR INGRESO ============== -->
    <div class="modal fade" id="modalIngreso" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title">
                        <i class="bi bi-clipboard-plus me-2"></i>Registrar ingreso a guardia
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <div class="alert alert-info mb-3">
                                <strong>Paciente:</strong> <span id="ingresoPacienteNombre"></span>
                                <span class="ms-3"><strong>DNI:</strong> <span id="ingresoPacienteDni"></span></span>
                            </div>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Descripción / motivo de consulta</label>
                            <asp:TextBox ID="txtDescSintomas" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"
                                placeholder="Escribí lo que te cuenta el paciente..."></asp:TextBox>
                            <small class="text-muted">El sistema calculará el estado (<strong>Espera</strong>) y la prioridad automáticamente. 
                    Los resultados arrojados serán evaluados por un enfermero.
                            </small>
                        </div>

                        <div class="col-12 d-flex align-items-center gap-3">
                            <span>Prioridad estimada: </span>
                            <span id="prioridadBadge" class="badge rounded-pill bg-secondary px-3 py-2">–</span>
                        </div>
                    </div>
                </div>

                <div class="modal-footer flex-column flex-sm-row gap-2">
                    <asp:Button ID="btnConfirmarIngreso" runat="server" CssClass="btn btn-success px-4"
                        Text="Confirmar ingreso" OnClick="btnConfirmarIngreso_Click" />
                    <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Cancelar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts específicos de la página (Bootstrap JS ya está en el master) -->
    <script>
        // Helpers para abrir modales con datos
        function openEditModal(id, dni, nombre, apellido, genero, telefono, email, obra, afiliado, fechaNac, Direccion) {

            Direccion = (typeof Direccion === "undefined" || Direccion === null) ? "" : Direccion;

            document.getElementById("<%= hfEditId.ClientID %>").value = id;
            document.getElementById("<%= txtEditDni.ClientID %>").value = dni;
            document.getElementById("<%= txtEditNombre.ClientID %>").value = nombre;
            document.getElementById("<%= txtEditApellido.ClientID %>").value = apellido;
            document.getElementById("<%= ddlEditGenero.ClientID %>").value = genero;
            document.getElementById("<%= txtEditTelefono.ClientID %>").value = telefono;
            document.getElementById("<%= txtEditEmail.ClientID %>").value = email;
            document.getElementById("<%= ddlEditObraSocial.ClientID %>").value = obra;
            document.getElementById("<%= txtEditNroAfiliado.ClientID %>").value = afiliado;
            document.getElementById("<%= txtEditFechaNac.ClientID %>").value = fechaNac;
            document.getElementById("<%= txtEditDireccion.ClientID %>").value = Direccion;

            // Ajustar el estado del afiliado según la obra social actual
            actualizarAfiliado(
        "<%= ddlEditObraSocial.ClientID %>",
        "<%= txtEditNroAfiliado.ClientID %>"
            );


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


    <%--Función de btn volver--%>
    <script>
        function safeBack() {
            // Página por defecto si no hay referrer o viene de otro sitio
            var fallbackUrl = '<%= ResolveUrl("~/Default.aspx") %>';

            // Referrer = página anterior (solo si es del mismo sitio)
            var ref = document.referrer;

            try {
                if (ref) {
                    var refUrl = new URL(ref);
                    // Solo usamos el referrer si es del mismo origen (misma app)
                    if (refUrl.origin === window.location.origin) {
                        window.location.href = ref;
                        return;
                    }
                }
            } catch (e) {
                // Si falla el parseo del URL, ignoramos y usamos fallback
            }

            // Si no hay referrer útil, vamos a la página por defecto
            window.location.href = fallbackUrl;
        }
    </script>

    <script>
        //Validación de DNI (Solo nros)
        function soloNumeros(e) {
            const key = e.key;
            if (!/^\d$/.test(key)) {
                e.preventDefault();
                return false;
            }
            return true;
        }
    </script>

    <script>
        // Abrir modal de ingreso con datos del paciente
        function openIngresoModal(pacienteId, nombreCompleto, dni) {
            document.getElementById("<%= hfIngresoPacienteId.ClientID %>").value = pacienteId;
            document.getElementById("ingresoPacienteNombre").innerText = nombreCompleto;
            document.getElementById("ingresoPacienteDni").innerText = dni;

            // limpiar campos previos
            document.getElementById("<%= txtDescSintomas.ClientID %>").value = "";
            setPrioridadPreview(0);

            // escuchar cambios para recalcular prioridad (Enfermero)
            setTimeout(() => {
                document.getElementById("<%= txtDescSintomas.ClientID %>").oninput = function () {
                    const prioridad = calcularPrioridad(this.value || "");
                    setPrioridadPreview(prioridad);
                    document.getElementById("<%= hfIngresoPrioridad.ClientID %>").value = prioridad;
                };
            }, 0);

            new bootstrap.Modal(document.getElementById('modalIngreso')).show();
        }

        // Heurística por palabras clave para calcular prioridad 1..5
        function calcularPrioridad(texto) {
            const t = (texto || "").toLowerCase();

            // P1: Rojo - Emergencia, atención inmediata
            const p1 = /(inconsciente|no respira|paro( cardiaco| cardiorrespiratorio)?|parada cardiaca|convuls(ion|iones)?|ataque epileptico|no responde|perdida de conocimiento|perdió el conocimiento|dolor (toracico|de pecho) intenso|dolor de pecho muy fuerte|opresion intensa en el pecho|sangrado (abundante|masivo|profuso)|mucha sangre|herida que no (para|deja) de sangrar|ahogo|ahogamiento|disnea severa|dificultad extrema para respirar|asfix(ia)?|labios morados|piel morada)/;

            // P2: Naranja - Muy urgente
            const p2 = /(fiebre (alta|muy alta|mas de 38|más de 38|> ?38)|temperatura (alta|39|40)|39.?c|40.?c|trauma craneal|golpe fuerte en la cabeza|golpe en la cabeza y mareos|dolor muy fuerte|dolor intenso|dolor insoportable|fractura|posible fractura|hemorragia|vomitos persistentes|vómitos persistentes|vomito con sangre|vómito con sangre|desmayo|se desmayo|se desmayó|perdida breve de conciencia|dolor en el pecho|dolor de pecho|palpitaciones fuertes|arritmia|dificultad importante para respirar|crisis asmatica|crisis asmática|ataque de asma)/;

            // P3: Amarillo - Urgente
            const p3 = /(mareo|mareos|sensacion de inestabilidad|sensación de inestabilidad|dolor moderado|dolor soportable|vomito|vómito|diarrea|gastroenteritis|infeccion|infección|herida|corte|esguince|torcedura|golpe|caida|caída|hipertension|hipertensión|presion alta|presión alta|tension alta|tensión alta|hipotension|hipotensión|presion baja|presión baja|tension baja|tensión baja|deshidratacion|deshidratación|malestar general|malestar corporal|dolor de cabeza fuerte pero tolerable)/;

            // P4: Verde - Menos urgente
            const p4 = /(dolor leve|molestia leve|molestia|control|consulta de rutina|control de rutina|chequeo|chequeo general|tos|resfriado|resfrio|gripe|catarro|dolor de garganta|dolor garganta|dolor de espalda leve|lumbalgia leve|medicacion|medicación|renovar receta|receta|curacion de herida|curación de herida|curacion|curación|sacar puntos|retirar puntos|quitar puntos|cambio de vendaje)/;

            if (p1.test(t)) return 1; // Rojo
            if (p2.test(t)) return 2; // Naranja
            if (p3.test(t)) return 3; // Amarillo
            if (p4.test(t)) return 4; // Verde
            return 5;                 // Azul (no urgente, por defecto)

            /*
                p1 --> Rojo (Inmediato) --> Riesgo vital inminente
                p2 --> Naranja (Muy urgente) --> Urgencia que puede deteriorarse rapidamente
                p3 --> Amarillo (Urgente) --> Urgencia aguda, no amenazante de la vida
                p4 --> Verde (Menos urgente) --> Condición que no pone en riesgo la vida
                p5 --> Azul (No urgente) --> Paciente sin urgencia clinica
            */
        }

        // Mostrar badge con color según prioridad
        function setPrioridadPreview(n) {
            const badge = document.getElementById("prioridadBadge");
            const clases = [
                "bg-secondary", // 0 (sin prioridad)
                "bg-danger",    // P1 - Rojo
                "bg-orange",    // P2 - Naranja
                "bg-warning",   // P3 - Amarillo
                "bg-success",   // P4 - Verde
                "bg-primary"    // P5 - Azul
            ];

            badge.className = "badge rounded-pill px-3 py-2 " + (clases[n] || "bg-secondary");
            badge.innerText = n > 0 ? ("P" + n) : "–";
        }

        // Limpia el afiliado cuando está editable (lo que ya usabas en oninput)
        function limpiarAfiliado(input) {
            if (input.readOnly) return; // si está bloqueado no toco el valor
            input.value = input.value.replace(/[^a-zA-Z0-9]/g, "").substring(0, 10);
        }

        // Activa / desactiva el textbox de afiliado según la Obra Social
        function actualizarAfiliado(obraClientId, afiliadoClientId) {
            var ddl = document.getElementById(obraClientId);
            var txt = document.getElementById(afiliadoClientId);
            if (!ddl || !txt) return;

            if (ddl.value === "SIN COBERTURA") {
                // Bloqueado, gris, con texto informativo
                txt.readOnly = true;
                txt.classList.add("bg-light", "text-muted");
                txt.value = "SIN COBERTURA";
            } else {
                // Habilitado de nuevo
                var estabaSinCobertura = (txt.value === "SIN COBERTURA");
                txt.readOnly = false;
                txt.classList.remove("bg-light", "text-muted");
                if (estabaSinCobertura) txt.value = ""; // limpio si venía de SIN COBERTURA
            }
        }

        // Cuando la página está lista, engancho los eventos y ajusto el estado inicial
        document.addEventListener("DOMContentLoaded", function () {

            // Alta
            var ddlAlta = document.getElementById("<%= ddlObraSocial.ClientID %>");
            var txtAlta = document.getElementById("<%= txtNroAfiliado.ClientID %>");
            if (ddlAlta && txtAlta) {
                actualizarAfiliado(ddlAlta.id, txtAlta.id);
                ddlAlta.addEventListener("change", function () {
                    actualizarAfiliado(ddlAlta.id, txtAlta.id);
                });
            }

            // Edición
            var ddlEdit = document.getElementById("<%= ddlEditObraSocial.ClientID %>");
            var txtEdit = document.getElementById("<%= txtEditNroAfiliado.ClientID %>");
            if (ddlEdit && txtEdit) {
                actualizarAfiliado(ddlEdit.id, txtEdit.id);
                ddlEdit.addEventListener("change", function () {
                    actualizarAfiliado(ddlEdit.id, txtEdit.id);
                });
            }
        });

    </script>

</asp:Content>
