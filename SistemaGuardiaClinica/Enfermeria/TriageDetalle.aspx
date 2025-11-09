<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="TriageDetalle.aspx.cs"
    Inherits="SistemaGuardiaClinica.Enfermeria.TriageDetalle"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        body { background: #f6f8fb; }
        .card { border-radius: 1rem; }
        .form-section-title {
            font-size: .85rem;
            text-transform: uppercase;
            letter-spacing: .05em;
            color: #6c757d;
            margin-bottom: .25rem;
        }
    </style>

    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div class="d-flex align-items-center gap-2">
                <a href='<%= ResolveUrl("~/Enfermeria/Triage.aspx") %>'
                   class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Volver
                </a>
                <h4 class="mb-0">
                    <i class="bi bi-clipboard2-pulse me-2"></i> Triage de enfermería
                </h4>
            </div>
        </div>

        <asp:PlaceHolder ID="phMsg" runat="server"></asp:PlaceHolder>

        <asp:Panel ID="pnlContenido" runat="server" CssClass="card shadow-sm">
            <div class="card-body">

                <!-- Datos del paciente / guardia -->
                <div class="alert alert-info d-flex flex-wrap align-items-center gap-3">
                    <div>
                        <strong>Paciente:</strong>
                        <asp:Label ID="lblPaciente" runat="server" />
                    </div>
                    <div>
                        <strong>DNI:</strong>
                        <asp:Label ID="lblDni" runat="server" />
                    </div>
                    <div>
                        <strong>Fecha ingreso:</strong>
                        <asp:Label ID="lblFechaIngreso" runat="server" />
                    </div>
                </div>

                <div class="row g-4">

                    <!-- Signos vitales -->
                    <div class="col-12">
                        <div class="form-section-title">Signos vitales</div>
                        <hr class="mt-1 mb-3" />
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Temperatura</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtTemperatura" runat="server"
                                         CssClass="form-control"
                                         MaxLength="4" />
                            <span class="input-group-text">°C</span>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Frecuencia cardíaca (FC)</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtFc" runat="server"
                                         CssClass="form-control"
                                         MaxLength="3" />
                            <span class="input-group-text">lpm</span>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Frecuencia respiratoria (FR)</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtFr" runat="server"
                                         CssClass="form-control"
                                         MaxLength="3" />
                            <span class="input-group-text">rpm</span>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Presión arterial (PA)</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtPaSistolica" runat="server"
                                         CssClass="form-control"
                                         MaxLength="3"
                                         placeholder="Sistólica" />
                            <span class="input-group-text">/</span>
                            <asp:TextBox ID="txtPaDiastolica" runat="server"
                                         CssClass="form-control"
                                         MaxLength="3"
                                         placeholder="Diastólica" />
                            <span class="input-group-text">mmHg</span>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Saturación O₂ (SpO₂)</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtSpo2" runat="server"
                                         CssClass="form-control"
                                         MaxLength="3" />
                            <span class="input-group-text">%</span>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Glucemia capilar</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtGlucemia" runat="server"
                                         CssClass="form-control"
                                         MaxLength="3" />
                            <span class="input-group-text">mg/dL</span>
                        </div>
                        <small class="text-muted">Opcional, si aplica.</small>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Glasgow</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtGlasgow" runat="server"
                                         CssClass="form-control"
                                         MaxLength="2" />
                            <span class="input-group-text">/15</span>
                        </div>
                        <small class="text-muted">Opcional, si aplica.</small>
                    </div>

                    <!-- Evaluación de riesgo -->
                    <div class="col-12 mt-3">
                        <div class="form-section-title">Evaluación de riesgo</div>
                            <hr class="mt-1 mb-3" />
                        </div>

                    <div class="col-md-6">
                        <label class="form-label">Especialidad requerida</label>
                            <asp:DropDownList ID="ddlEspecialidad" runat="server"
                                CssClass="form-select"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="ddlEspecialidad_SelectedIndexChanged">
                            </asp:DropDownList>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Derivar a especialista</label>
                        <asp:DropDownList ID="ddlEspecialista" runat="server" CssClass="form-select">
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Nivel de urgencia / color de triage</label>
                            <asp:RadioButtonList ID="rblNivelUrgencia" runat="server"
                                CssClass="d-flex flex-column gap-1">
                            <asp:ListItem Value="Rojo">Emergencia – atención inmediata</asp:ListItem>
                            <asp:ListItem Value="Naranja">Muy urgente</asp:ListItem>
                            <asp:ListItem Value="Amarillo">Urgente – atención &lt; 30 min</asp:ListItem>
                            <asp:ListItem Value="Verde">No urgente – puede esperar</asp:ListItem>
                            <asp:ListItem Value="Azul">Leve / administrativa</asp:ListItem>
                            </asp:RadioButtonList>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Observaciones de enfermería</label>
                        <asp:TextBox ID="txtObsEnfermero" runat="server"
                            CssClass="form-control"
                            TextMode="MultiLine"
                            Rows="4"
                            placeholder="Notas adicionales sobre el estado del paciente..."></asp:TextBox>
                    </div>

            <div class="card-footer d-flex flex-column flex-sm-row gap-2 justify-content-between">
                <div class="d-flex flex-column flex-sm-row gap-2">
                    <asp:Button ID="btnEnviarEspecialista" runat="server"
                                CssClass="btn btn-success px-4"
                                Text="Enviar a especialista"
                                OnClick="btnEnviarEspecialista_Click" />

                    <asp:Button ID="btnGuardar" runat="server"
                                CssClass="btn btn-primary px-4"
                                Text="Aceptar"
                                OnClick="btnGuardar_Click" />
                </div>

                <asp:Button ID="btnCancelar" runat="server"
                            CssClass="btn btn-outline-secondary px-4"
                            Text="Cancelar"
                            CausesValidation="false"
                            OnClick="btnCancelar_Click" />
            </div>
        </asp:Panel>
    </div>

</asp:Content>