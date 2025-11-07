<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestBD.aspx.cs" 
    Inherits="SistemaGuardiaClinica.TestBD" %>

<!DOCTYPE html>
<html>
<head>
    <title>Test Base de Datos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <div class="container mt-5">
            <h1>Test de Conexión a Base de Datos</h1>
            
            <div class="card mb-3">
                <div class="card-header">
                    <h5>Connection Strings para Probar</h5>
                </div>
                <div class="card-body">
                    <asp:Label ID="lblInfo" runat="server" Text="" CssClass="text-muted d-block mb-3"></asp:Label>
                    
                    <div class="mb-3">
                        <asp:Button ID="btnTest1" runat="server" Text="Probar: localhost\\SQLEXPRESS" 
                            CssClass="btn btn-primary me-2 mb-2" OnClick="btnTest1_Click" />
                        <asp:Button ID="btnTest2" runat="server" Text="Probar: .\\SQLEXPRESS" 
                            CssClass="btn btn-secondary me-2 mb-2" OnClick="btnTest2_Click" />
                        <asp:Button ID="btnTest3" runat="server" Text="Probar: (local)\\SQLEXPRESS" 
                            CssClass="btn btn-info me-2 mb-2" OnClick="btnTest3_Click" />
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <asp:Button ID="btnTestLogin" runat="server" Text="Probar Login con EF6" 
                    CssClass="btn btn-success me-2" OnClick="btnTestLogin_Click" />
                <asp:Button ID="btnVerTablas" runat="server" Text="Ver Tablas y Datos" 
                    CssClass="btn btn-warning" OnClick="btnVerTablas_Click" />
            </div>
            
            <asp:Label ID="lblResultado" runat="server" Text="" CssClass="d-block mt-3"></asp:Label>
        </div>
    </form>
</body>
</html>