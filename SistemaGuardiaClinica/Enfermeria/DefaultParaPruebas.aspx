<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DefaultParaPruebas.aspx.cs" 
    Inherits="SistemaGuardiaClinica.Enfermeria.Default" %>

<!DOCTYPE html>
<html>
<head>
    <title>Enfermería - Sistema Guardia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-enfermero">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-hospital"></i> Guardia Clínica - Enfermería
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3" id="lblUsuario" runat="server"></span>
                <a href="../Default.aspx" class="btn btn-outline-danger btn-sm">Cerrar Sesión</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-3">
        <div class="alert alert-success">
            <h4>✅ ¡Bienvenido a Enfermería!</h4>
            <p>Has accedido como <strong id="lblRol" runat="server"></strong></p>
        </div>
        <a href="../Default.aspx" class="btn btn-primary">Volver al Inicio</a>
    </div>
</body>
</html>