<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" 
    Inherits="SistemaGuardiaClinica.Login" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login - Sistema Guardia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        // Prevenir que el formulario se envíe múltiples veces
        function disableButton(btn) {
            btn.disabled = true;
            btn.value = 'Procesando...';
            return true;
        }
    </script>
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-4">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white text-center">
                        <h4><i class="fas fa-hospital"></i> Sistema de Guardia</h4>
                    </div>
                    <div class="card-body">
                        <form id="form1" runat="server">
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" 
                                    TextMode="Email" required="true"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Password</label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" 
                                    TextMode="Password" required="true"></asp:TextBox>
                            </div>
                            <asp:Button ID="btnLogin" runat="server" Text="Iniciar Sesión"
                                CssClass="btn btn-primary w-100" OnClick="btnLogin_Click" UseSubmitBehavior="true" />

                            <asp:ValidationSummary ID="valSummary" runat="server" CssClass="alert alert-danger mb-3" 
                                HeaderText="Revisá estos errores:" ShowSummary="true" />
                            <asp:Label ID="lblMensaje" runat="server" EnableViewState="false" CssClass="text-danger d-block"></asp:Label>

                            
                            <div class="mt-3 text-center">
                                <a href="Reset.aspx" class="text-muted small">¿Problemas de acceso? Limpiar sesión</a>
                            </div>

                            <hr>
                            <div class="text-center">
                                <small class="text-muted">Credenciales de prueba:</small><br>
                                <small class="text-muted"><strong>recepcion@clinica.com</strong> / 123456</small><br>
                                <small class="text-muted"><strong>enfermeria@clinica.com</strong> / 123456</small><br>
                                <small class="text-muted"><strong>cardio@clinica.com</strong> / 123456</small>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>