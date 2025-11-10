<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="ConsultaMedica.aspx.cs"
    Inherits="SistemaGuardiaClinica.Medicos.ConsultaMedica"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <style>
        body {
            background: #f6f8fb;
        }

        .card {
            border-radius: 1rem;
        }

        .table td, .table th {
            vertical-align: middle;
        }

        .row-pr-1 {
            --bs-table-bg: #fdecea;
        }
        /* Rojo suave - P1 (Inmediato) */
        .row-pr-2 {
            --bs-table-bg: #fff3cd;
        }
        /* Naranja suave - P2 (Muy urgente) */
        .row-pr-3 {
            --bs-table-bg: #fff7e6;
        }
        /* Amarillo suave - P3 (Urgente) */
        .row-pr-4 {
            --bs-table-bg: #edf7ee;
        }
        /* Verde suave - P4 (Menos urgente) */
        .row-pr-5 {
            --bs-table-bg: #e7f1ff;
        }
        /* Azul suave - P5 (No urgente) */
        .bg-prio-orange {
            background-color: #fd7e14 !important;
        }
        /* Naranja Bootstrap-like */
    </style>

    <div class="container py-4">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h4 class="mb-0">
                <i class="bi bi-person-check me-2"></i>Pacientes Triageados (Listos para consulta)
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
                                    <th>Síntomas (Triage)</th>
                                    <th style="width: 130px;">Prioridad</th>
                                    <th style="width: 120px;">Estado</th>
                                    <th style="width: 290px;"><%= new string('\n', 20).Replace("\n", "&nbsp;") %>Acciones</th>
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

                    <td>
                        <asp:Literal runat="server" Mode="PassThrough"
                            Text='<%# GetEstadoBadge(Convert.ToString(Eval("Estado"))) %>' />
                    </td>

                    <td class="text-end">
                        <%-- si está atendido, deshabilito el botón de consulta --%>
                        <button type="button"
                            class='btn btn-sm <%# Convert.ToString(Eval("Estado")) == "Atendido" ? "btn-outline-secondary" : "btn-primary" %>'
                            <%# Convert.ToString(Eval("Estado")) == "Atendido" ? "disabled=\"disabled\"" : "" %>
                            onclick='openConsultaModal(
                                "<%# Eval("Id") %>",
                                "<%# (Eval("Paciente.Apellido") + ", " + Eval("Paciente.Nombre")).ToString().Replace("\"","\\\"") %>"
                                )'>
                            <i class="bi bi-play-circle me-1"></i>
                            <%# Convert.ToString(Eval("Estado")) == "Atendido" ? "Atendido" : "Iniciar Consulta" %>
                        </button>

                        <%-- Historia clínica: solo clickeable cuando Estado = Atendido --%>
                        <a runat="server"
                            class='btn btn-sm ms-2 <%# Convert.ToString(Eval("Estado")) == "Atendido" 
                                    ? "btn-outline-secondary" 
                                    : "btn-outline-secondary disabled" %>'
                            href='<%# Convert.ToString(Eval("Estado")) == "Atendido" ? ResolveUrl("~/Medicos/HistoriaClinica.aspx?pacienteId=" + Eval("PacienteId")) : "#" %>'
                            onclick='<%# Convert.ToString(Eval("Estado")) == "Atendido" ? "" : "return false;" %>'>
                            <i class="bi bi-journal-text me-1"></i>Historia
                        </a>
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
                        <i class="bi bi-file-earmark-medical me-2"></i>Consulta Médica
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body">
                    <div class="alert alert-info">
                        <strong>Paciente:</strong> <span id="consultaPacienteNombre"></span>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Notas de Consulta / Diagnóstico</label>
                        <asp:TextBox ID="txtConsultaNotas" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="6"
                            placeholder="Escriba el diagnóstico, tratamiento, notas..."></asp:TextBox>
                    </div>

                    <div class="form-check mb-2">
                        <asp:CheckBox ID="chkTieneMedicamentos" runat="server"
                            CssClass="form-check-input"
                            onclick="toggleMedicamentos()" />
                        <label class="form-check-label" for="<%= chkTieneMedicamentos.ClientID %>">
                            Indicar medicamentos
                        </label>
                    </div>

                    <div id="divMedicamentos" class="mb-3" style="display: none;">
                        <label class="form-label">Medicamentos</label>
                        <asp:DropDownList ID="ddlMedicamentos" runat="server" CssClass="form-select">
                            <asp:ListItem Value="">-- Seleccione --</asp:ListItem>
                            <asp:ListItem>Paracetamol 500 mg c/8 hs</asp:ListItem>
                            <asp:ListItem>Ibuprofeno 400 mg c/8 hs</asp:ListItem>
                            <asp:ListItem>Omeprazol 20 mg desayuno</asp:ListItem>
                            <asp:ListItem>Amoxicilina 500 mg c/8 hs 7 días</asp:ListItem>
                            <asp:ListItem>Salbutamol inhalador 2 puff c/6 hs</asp:ListItem>
                            <%-- lo que quieras agregar --%>
                        </asp:DropDownList>
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

    <script>
        function toggleMedicamentos() {
            var chk = document.getElementById("<%= chkTieneMedicamentos.ClientID %>");
            var div = document.getElementById("divMedicamentos");
            if (!chk || !div) return;
            div.style.display = chk.checked ? "block" : "none";
        }

        // si reusás el modal, asegúrate de resetear el estado al abrir
        function openConsultaModal(guardiaId, nombre) {
            document.getElementById("<%= hfConsultaGuardiaId.ClientID %>").value = guardiaId;
            document.getElementById("consultaPacienteNombre").innerText = nombre;

            document.getElementById("<%= txtConsultaNotas.ClientID %>").value = "";

            var chk = document.getElementById("<%= chkTieneMedicamentos.ClientID %>");
            var div = document.getElementById("divMedicamentos");
            var ddl = document.getElementById("<%= ddlMedicamentos.ClientID %>");
            if (chk) chk.checked = false;
            if (div) div.style.display = "none";
            if (ddl) ddl.selectedIndex = 0;

            new bootstrap.Modal(document.getElementById('modalConsulta')).show();
        }
    </script>

</asp:Content>
