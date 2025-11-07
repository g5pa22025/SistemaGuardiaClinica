<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" 
    Inherits="SistemaGuardiaClinica.Recepcionista.Default" %>

<!DOCTYPE html>
<html>
<head>
    <title>Recepción - Sistema Guardia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-recepcionista">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-hospital"></i> Guardia Clínica - Recepción
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3" id="lblUsuario" runat="server"></span>
                <a href="../Default.aspx" class="btn btn-outline-danger btn-sm">Cerrar Sesión</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-3">
        <div class="row">
            <div class="col-md-12">
                <h2><i class="fas fa-user-injured"></i> Recepción - Gestión de Pacientes</h2>
                <hr />
                
                <div class="alert alert-success">
                    <h4>✅ ¡Login exitoso!</h4>
                    <p>Has accedido como <strong id="lblRol" runat="server"></strong></p>
                    <p>Esta es la pantalla de recepción (versión temporal)</p>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h5>Funcionalidades de Recepción</h5>
                    </div>
                    <div class="card-body">
                        <ul>
                            <li>Buscar paciente por DNI</li>
                            <li>Registrar nuevo paciente</li>
                            <li>Asignar a guardia</li>
                            <li>Gestión de turnos de emergencia</li>
                        </ul>
                        
                        <a href="../Default.aspx" class="btn btn-primary">Volver al Inicio</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>