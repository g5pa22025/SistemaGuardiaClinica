<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" 
    Inherits="SistemaGuardiaClinica.Login" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login - Sistema Guardia</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <style>
        body {
            background: linear-gradient(135deg, #e9f0ff, #f8f9fa);
            min-height: 100vh;
        }

        .login-card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            margin-top: 6vh;
        }

        .login-header {
            background: #0d6efd;
            border-top-left-radius: 1rem;
            border-top-right-radius: 1rem;
            color: #fff;
            text-align: center;
            padding: 1rem;
        }

        .form-select:focus, .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13,110,253,.25);
        }

        .text-muted.small {
            font-size: .85rem;
        }
    </style>

    <script type="text/javascript">
        // Deshabilitar botón SOLO si el formulario es válido
        function disableButton(btn) {
            try {
                var form = document.getElementById('form1');

                if (form && !form.checkValidity) {
                    // Navegador viejo: no sabe validar, seguimos normal
                    btn.disabled = true;
                    btn.value = 'Procesando...';
                    return true;
                }

                if (form && !form.checkValidity()) {
                    // Disparamos la validación nativa (mensajes rojos del navegador)
                    form.reportValidity();
                    // NO deshabilitamos el botón, cancelamos el submit
                    return false;
                }

                // Si es válido, recién ahí deshabilitamos
                btn.disabled = true;
                btn.value = 'Procesando...';
                return true;
            } catch (e) {
                // Si algo raro pasa en JS, no bloqueamos el submit
                console.error(e);
                return true;
            }
        }

        // Completar email desde el select de usuarios demo
        function cargarUsuarioDemo(select) {
            var email = select.value;
            if (!email) return;

            var txtEmail = document.getElementById('<%= txtEmail.ClientID %>');
            if (txtEmail) txtEmail.value = email;

            // limpiar password al cambiar usuario
            var txtPassword = document.getElementById('<%= txtPassword.ClientID %>');
            if (txtPassword) {
                txtPassword.value = "";
                txtPassword.focus();
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server" novalidate>
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-5">
                    <div class="card login-card">
                        <div class="login-header">
                            <h4 class="mb-0">
                                <i class="bi bi-hospital me-2"></i> Sistema de Guardia
                            </h4>
                        </div>

                        <div class="card-body p-4">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Seleccionar usuario</label>
                                <select id="ddlUsuariosDemo" class="form-select"
                                        onchange="cargarUsuarioDemo(this)">
                                    <option value="">-- Elegí un usuario --</option>
                                    <option value="recepcion@clinica.com">Recepción</option>
                                    <option value="enfermeria@clinica.com">Enfermería</option>
                                    <optgroup label="Médicos">
                                        <option value="clinica@clinica.com">Clínico</option>
                                        <option value="cardio@clinica.com">Cardiólogo</option>
                                        <option value="trauma@clinica.com">Traumatólogo</option>
                                        <option value="pediatria@clinica.com">Pediatra</option>
                                        <option value="neuro@clinica.com">Neurólogo</option>
                                        <option value="gastro@clinica.com">Gastroenterólogo</option>
                                    </optgroup>
                                </select>
                                <small class="text-muted small">
                                    Al seleccionar un usuario se completa automáticamente el email. La contraseña SIEMPRE la escribís vos.
                                </small>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Email</label>
                                <asp:TextBox ID="txtEmail" runat="server"
                                             CssClass="form-control"
                                             TextMode="Email"
                                             placeholder="usuario@clinica.com"
                                             required="true"></asp:TextBox>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold">Contraseña</label>
                                <asp:TextBox ID="txtPassword" runat="server"
                                             CssClass="form-control"
                                             TextMode="Password"
                                             placeholder="Ingresá tu contraseña"
                                             required="true"></asp:TextBox>
                            </div>

                            <asp:Button ID="btnLogin" runat="server"
                                        Text="Iniciar Sesión"
                                        CssClass="btn btn-primary w-100"
                                        OnClick="btnLogin_Click"
                                         />
                            <%--OnClientClick="return disableButton(this);"--%>

                            <asp:ValidationSummary ID="valSummary" runat="server"
                                                   CssClass="alert alert-danger mt-3 mb-2"
                                                   HeaderText="Revisá estos errores:"
                                                   ShowSummary="true" />

                            <asp:Label ID="lblMensaje" runat="server"
                                       EnableViewState="false"
                                       CssClass="text-danger d-block"></asp:Label>

                            <div class="mt-3 text-center">
                                <a href="Reset.aspx" class="text-muted small">
                                    ¿Problemas de acceso? Limpiar sesión
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>