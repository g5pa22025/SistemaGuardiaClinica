<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="ConsultaMedica.aspx.cs"
    Inherits="SistemaGuardiaClinica.Medicos.ConsultaMedica"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <style>
        body { background: #f6f8fb; }
        .card { border-radius: 1rem; }
        .table td, .table th { vertical-align: middle; }
        .row-pr-1, .row-pr-2 { --bs-table-bg: #edf7ee; }
        .row-pr-3, .row-pr-4 { --bs-table-bg: #fff7e6; }
        .row-pr-5 { --bs-table-bg: #fdecea; }
    </style>

    <div class="container py-4">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h4 class="mb-0">
                <i class="bi bi-person-check me-2"></i> Pacientes Triageados (Listos para consulta)
            </h4>
        </div>

        <asp:PlaceHolder ID="phMsg" runat="server"></asp:PlaceHolder>

        <asp:Repeater ID="rpTriageados" runat="server">
            <HeaderTemplate>
                <div class="card shadow-sm">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Fecha Ingreso</th>
                                    <th>DNI</th>
                                    <th>Paciente</th>
                                    <th style="width:40%">Síntomas (Triage)</th>
                                    <th>Prioridad</th>
                                    <th class="text-end" style="width: 220px;"></th>
                                </tr>
                            </thead>
                            <tbody>
            </HeaderTemplate>

            <ItemTemplate>
                <tr class='<%# GetRowClass((int?)Eval("PrioridadFinal")) %>'>
                    <td><%# Eval("FechaIngreso", "{0:dd/MM/yyyy HH:mm}") %></td>
                    <td><%# Eval("Paciente.DNI") %></td>
                    <td><%# Eval("Paciente.Apellido") %>, <%# Eval("Paciente.Nombre") %></td>
                    <td class="text-muted"><%# Eval("Sintomas") %></td>
                    <td>
                        <asp:Literal runat="server" Mode="PassThrough"
                            Text='<%# GetBadge((int?)Eval("PrioridadFinal")) %>' />
                    </td>
                    <td class="text-end">
                        <button type="button" class="btn btn-sm btn-primary"
                           onclick='openConsultaModal(
                                "<%# Eval("Id") %>",
                                "<%# (Eval("Paciente.Apellido") + ", " + Eval("Paciente.Nombre")).ToString().Replace("\"","\\\"") %>"
                            )'>
                            <i class="bi bi-play-circle me-1"></i> Iniciar Consulta
                        </button>
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

    <asp:HiddenField ID="hfConsultaGuardiaId" runat="server" />

    <div class="modal fade" id="modalConsulta" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">
                        <i class="bi bi-file-earmark-medical me-2"></i> Consulta Médica
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body">
                    <div class="alert alert-info">
                        <strong>Paciente:</strong> <span id="consultaPacienteNombre"></span>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Notas de Consulta / Diagnóstico</label>
                        <asp:TextBox ID="txtConsultaNotas" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6"
                            placeholder="Escriba el diagnóstico, tratamiento, notas..."></asp:TextBox>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Cancelar</button>
                    
                    <asp:Button ID="btnFinalizarConsulta" runat="server" CssClass="btn btn-primary px-4"
                        Text="Finalizar Consulta" OnClick="btnFinalizarConsulta_Click" />
                </div>
            </div>
        </div>
    </div>

    <script>
        // Abre modal de consulta y setea datos
        function openConsultaModal(guardiaId, nombre) {
            document.getElementById("<%= hfConsultaGuardiaId.ClientID %>").value = guardiaId;
            document.getElementById("consultaPacienteNombre").innerText = nombre;

            // Limpiamos notas previas si el modal se reutiliza
            document.getElementById("<%= txtConsultaNotas.ClientID %>").value = "";

            new bootstrap.Modal(document.getElementById('modalConsulta')).show();
        }
    </script>
</asp:Content>