<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reset.aspx.cs" 
    Inherits="SistemaGuardiaClinica.Reset" %>

<!DOCTYPE html>
<html>
<head>
    <title>Reset Sistema</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <form id="form1" runat="server"> 
        <div class="container text-center mt-5">
            <div class="card shadow mx-auto" style="max-width: 500px;">
                <div class="card-header bg-warning text-dark">
                    <h4><i class="fas fa-sync-alt"></i> Reset del Sistema</h4>
                </div>
                <div class="card-body">
                    <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
                    <div class="mt-3">
                        <asp:Button ID="btnReset" runat="server" Text="Limpiar Sesión y Cookies" 
                            CssClass="btn btn-danger w-100" OnClick="btnReset_Click" />
                        <a href="Default.aspx" class="btn btn-secondary w-100 mt-2">Volver al Inicio</a>
                    </div>
                </div>
            </div>
        </div>
    </form> 
</body>
</html>