<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="HistoriaClinica.aspx.cs"
    Inherits="SistemaGuardiaClinica.Medicos.HistoriaClinica"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <style>
        body { background: #f6f8fb; }
        .card { border-radius: 1rem; }
        .table td, .table th { vertical-align: top; }
        .hc-header { border-bottom: 1px solid #e9ecef; }
    </style>

    <div class="container py-4">
        <div class="d-flex align-items-center justify-content-between mb-3 hc-header">
            <div class="d-flex align-items-center gap-3">
                <button type="button" class="btn btn-outline-dark d-flex align-items-center"
                        onclick="history.back()">
                    <i class="bi bi-arrow-left me-1"></i> Volver
                </button>
                <h4 class="mb-0">
                    <i class="bi bi-journal-medical me-2"></i>Historia clínica
                </h4>
            </div>

            <div class="d-flex gap-2">
                <asp:Button ID="btnDescargarPdf" runat="server"
                            CssClass="btn btn-outline-primary"
                            Text="Descargar PDF"
                            OnClick="btnDescargarPdf_Click" />
            </div>
        </div>

        <asp:PlaceHolder ID="phMsg" runat="server"></asp:PlaceHolder>

        <div class="card shadow-sm mb-3">
            <div class="card-body">
                <h5 class="card-title mb-1" id="tituloPaciente">
                    <asp:Label ID="lblPaciente" runat="server" Text="Paciente"></asp:Label>
                </h5>
                <p class="mb-0 text-muted">
                    <asp:Label ID="lblPacienteDatos" runat="server"></asp:Label>
                </p>
            </div>
        </div>

        <asp:Repeater ID="rpHistoria" runat="server">
            <HeaderTemplate>
                <div class="card shadow-sm">
                    <div class="table-responsive">
                        <table class="table table-striped mb-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th style="width: 160px;">Fecha ingreso</th>
                                    <th style="width: 110px;">Estado</th>
                                    <th>Síntomas / Triage</th>
                                    <th>Signos vitales</th>
                                    <th>Diagnóstico y tratamiento</th>
                                </tr>
                            </thead>
                            <tbody>
            </HeaderTemplate>

            <ItemTemplate>
                <tr>
                    <td>
                        <%# Eval("FechaIngreso", "{0:dd/MM/yyyy HH:mm}") %>
                    </td>
                    <td>
                        <asp:Literal runat="server" Mode="PassThrough"
                            Text='<%# GetEstadoBadge(Convert.ToString(Eval("Estado"))) %>' />
                        <br />
                        <small class="text-muted">
                            Prioridad:
                            <asp:Literal runat="server" Mode="PassThrough"
                                Text='<%# GetBadge((int?)Eval("PrioridadFinal")) %>' />
                        </small>
                    </td>
                    <td>
                        <strong>Síntomas:</strong>
                        <div><%# Eval("Sintomas") %></div>
                        <br />
                        <strong>Obs. Enfermería:</strong>
                        <div><%# Eval("ObservacionesEnfermero") %></div>
                        <br />
                        <strong>Especialidad requerida:</strong>
                        <div><%# Eval("EspecialidadRequerida") %></div>
                    </td>
                    <td>
                        <small>
                            T°: <%# Eval("Temperatura") %> °C<br />
                            FC: <%# Eval("FrecuenciaCardiaca") %> lpm<br />
                            FR: <%# Eval("FrecuenciaRespiratoria") %> rpm<br />
                            PA: <%# Eval("PresionSistolica") %>/<%# Eval("PresionDiastolica") %> mmHg<br />
                            SatO₂: <%# Eval("SaturacionOxigeno") %> %<br />
                            Glucemia: <%# Eval("Glucemia") %> mg/dl<br />
                            Glasgow: <%# Eval("Glasgow") %>
                        </small>
                    </td>
                    <td>
                        <strong>Diagnóstico médico:</strong>
                        <div><%# Eval("DiagnosticoMedico") %></div>
                        <br />
                        <strong>Medicamentos:</strong>
                        <div><%# Eval("Medicamentos") %></div>
                    </td>
                </tr>
            </ItemTemplate>

            <FooterTemplate>
                            </tbody>
                        </table>
                    </div>
                </div>
            </FooterTemplate>
        </asp:Repeater>

    </div>

</asp:Content>