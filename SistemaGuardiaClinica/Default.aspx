<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs"
    Inherits="SistemaGuardiaClinica.Default"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblUsuario" runat="server" CssClass="h5 d-block mb-3"></asp:Label>

    <!-- Mensajes -->
    <asp:PlaceHolder ID="phMsg" runat="server"></asp:PlaceHolder>

    <!-- Panel común visible para todos -->
    <div class="card mb-4">
        <div class="card-body">
            <h5 class="card-title">Resumen</h5>
            <p class="card-text">Bienvenido al sistema. El contenido de abajo se adapta según tu rol.</p>
        </div>
    </div>

    <!-- Recepcionista -->
    <asp:Panel ID="panelRecepcion" runat="server" Visible="false" CssClass="mb-4">
    <div class="card border-primary shadow-sm rounded-3">
        <div class="card-header bg-primary text-white fw-bold">
            <i class="bi bi-person-lines-fill me-2"></i> Recepción
        </div>

        <div class="card-body">
            <p class="card-text mb-3 text-secondary">
                Accesos rápidos para Recepcionista:
            </p>

            <div class="d-flex flex-wrap gap-3">
                <a runat="server" href="~/Pacientes/ABM.aspx"
                   class="btn btn-outline-primary d-flex align-items-center gap-2 px-3">
                    <i class="bi bi-people-fill"></i>
                    <span>Gestión de Pacientes</span>
                </a>
            </div>
        </div>
    </div>
</asp:Panel>

    <!-- Enfermería -->
    <asp:Panel ID="panelEnfermeria" runat="server" Visible="false" CssClass="mb-4">
    <div class="card border-success shadow-sm rounded-3">
        <div class="card-header bg-success text-white fw-bold">
            <i class="bi bi-heart-pulse me-2"></i> Enfermería
        </div>

        <div class="card-body">
            <p class="card-text mb-3 text-secondary">
                Accesos rápidos para Enfermero/a:
            </p>

            <div class="d-flex flex-wrap gap-3">
                <a runat="server" href="~/Enfermeria/Triage.aspx"
                   class="btn btn-outline-success d-flex align-items-center gap-2 px-3">
                    <i class="bi bi-activity"></i>
                    <span>Triage / Signos Vitales</span>
                </a>

                <a runat="server" href="~/Guardia/Derivacion.aspx"
                   class="btn btn-outline-warning d-flex align-items-center gap-2 px-3">
                    <i class="bi bi-arrow-left-right"></i>
                    <span>Derivación a Médico</span>
                </a>
            </div>
        </div>
    </div>
</asp:Panel>

    <!-- Médicos -->
    <asp:Panel ID="panelMedico" runat="server" Visible="false" CssClass="mb-4">
    <div class="card border-warning shadow-sm rounded-3">
        <div class="card-header bg-warning text-dark fw-bold">
            <i class="bi bi-stethoscope me-2"></i> Médico
        </div>

        <div class="card-body">
            <p class="card-text mb-3 text-secondary">
                Accesos rápidos para Médico/a:
            </p>

            <div class="d-flex flex-wrap gap-3">
                <a runat="server" href="~/Medico/Atencion.aspx"
                   class="btn btn-outline-warning d-flex align-items-center gap-2 px-3">
                    <i class="bi bi-clipboard2-pulse"></i>
                    <span>Atender Paciente</span>
                </a>

                <a runat="server" href="~/Medico/HistoriaClinica.aspx"
                   class="btn btn-outline-primary d-flex align-items-center gap-2 px-3">
                    <i class="bi bi-journal-medical"></i>
                    <span>Historia Clínica</span>
                </a>

                <a runat="server" href="~/Guardia/Listado.aspx"
                   class="btn btn-outline-success d-flex align-items-center gap-2 px-3">
                    <i class="bi bi-list-check"></i>
                    <span>Pacientes en Guardia</span>
                </a>
            </div>
        </div>
    </div>
</asp:Panel>

</asp:Content>