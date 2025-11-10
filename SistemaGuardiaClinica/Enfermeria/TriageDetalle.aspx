<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="TriageDetalle.aspx.cs"
    Inherits="SistemaGuardiaClinica.Enfermeria.TriageDetalle"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        body {
            background: #f6f8fb;
        }

        .card {
            border-radius: 1rem;
        }

        .form-section-title {
            font-size: .85rem;
            text-transform: uppercase;
            letter-spacing: .05em;
            color: #6c757d;
            margin-bottom: .25rem;
        }

        .triage-list {
            list-style: none;
            padding-left: 0;
            margin-bottom: 0;
        }

            .triage-list li {
                display: flex;
                align-items: center;
                gap: .5rem;
                padding: .35rem .75rem;
                border-radius: .75rem;
                border: 1px solid transparent;
                cursor: pointer;
                transition: background-color .15s ease, border-color .15s ease, box-shadow .15s ease;
            }

                /* hover */
                .triage-list li:hover {
                    background-color: #f8f9fa;
                    border-color: #dee2e6;
                    box-shadow: 0 0 0 .1rem rgba(13,110,253,.1);
                }

            .triage-list input[type=radio] {
                margin: 0;
            }

            .triage-list li label {
                margin: 0;
                cursor: pointer;
            }

                /* bolita de color antes del texto */
                .triage-list li label::before {
                    content: "";
                    display: inline-block;
                    width: 10px;
                    height: 10px;
                    border-radius: 999px;
                    margin-right: .45rem;
                    vertical-align: middle;
                }

            /* Rojo, Naranja, Amarillo, Verde, Azul (según el orden de los items) */
            .triage-list li:nth-child(1) label::before {
                background-color: #dc3545;
            }
            /* Rojo */
            .triage-list li:nth-child(2) label::before {
                background-color: #fd7e14;
            }
            /* Naranja */
            .triage-list li:nth-child(3) label::before {
                background-color: #ffc107;
            }
            /* Amarillo */
            .triage-list li:nth-child(4) label::before {
                background-color: #198754;
            }
            /* Verde */
            .triage-list li:nth-child(5) label::before {
                background-color: #0d6efd;
            }
            /* Azul */

            /* estado seleccionado */
            .triage-list li input[type=radio]:checked + label {
                font-weight: 600;
            }

                .triage-list li input[type=radio]:checked + label::after {
                    content: " ✓";
                    font-size: .8rem;
                    color: #198754;
                    margin-left: .25rem;
                }
    </style>

    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div class="d-flex align-items-center gap-2">
                <a href='<%= ResolveUrl("~/Enfermeria/Triage.aspx") %>'
                    class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i>Volver
                </a>
                <h4 class="mb-0">
                    <i class="bi bi-clipboard2-pulse me-2"></i>Triage de enfermería
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

                    <!-- Temperatura (decimal) -->
                    <div class="col-md-4">
                        <label class="form-label">Temperatura</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtTemperatura" runat="server"
                                CssClass="form-control"
                                MaxLength="4"
                                oninput="limitarDecimalPositivo(this)" />
                            <span class="input-group-text">°C</span>
                        </div>
                        <asp:RegularExpressionValidator ID="revTemperatura" runat="server"
                            ControlToValidate="txtTemperatura"
                            CssClass="text-danger"
                            Display="Dynamic"
                            ValidationExpression="^([0-9]+([.,][0-9]{1,2})?)?$"
                            ErrorMessage="Temperatura inválida: solo números positivos." />
                    </div>

                    <!-- Frecuencia cardíaca -->
                    <div class="col-md-4">
                        <label class="form-label">Frecuencia cardíaca (FC)</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtFc" runat="server"
                                CssClass="form-control"
                                MaxLength="3"
                                oninput="limitarEnteroPositivo(this)" />
                            <span class="input-group-text">lpm</span>
                        </div>
                        <asp:RegularExpressionValidator ID="revFc" runat="server"
                            ControlToValidate="txtFc"
                            CssClass="text-danger"
                            Display="Dynamic"
                            ValidationExpression="^[0-9]*$"
                            ErrorMessage="FC inválida: solo números positivos." />
                    </div>

                    <!-- Frecuencia respiratoria -->
                    <div class="col-md-4">
                        <label class="form-label">Frecuencia respiratoria (FR)</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtFr" runat="server"
                                CssClass="form-control"
                                MaxLength="3"
                                oninput="limitarEnteroPositivo(this)" />
                            <span class="input-group-text">rpm</span>
                        </div>
                        <asp:RegularExpressionValidator ID="revFr" runat="server"
                            ControlToValidate="txtFr"
                            CssClass="text-danger"
                            Display="Dynamic"
                            ValidationExpression="^[0-9]*$"
                            ErrorMessage="FR inválida: solo números positivos." />
                    </div>

                    <!-- Presión arterial -->
                    <div class="col-md-6">
                        <label class="form-label">Presión arterial (PA)</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtPaSistolica" runat="server"
                                CssClass="form-control"
                                MaxLength="3"
                                placeholder="Sistólica"
                                oninput="limitarEnteroPositivo(this)" />
                            <span class="input-group-text">/</span>
                            <asp:TextBox ID="txtPaDiastolica" runat="server"
                                CssClass="form-control"
                                MaxLength="3"
                                placeholder="Diastólica"
                                oninput="limitarEnteroPositivo(this)" />
                            <span class="input-group-text">mmHg</span>
                        </div>
                        <asp:RegularExpressionValidator ID="revPaSis" runat="server"
                            ControlToValidate="txtPaSistolica"
                            CssClass="text-danger"
                            Display="Dynamic"
                            ValidationExpression="^[0-9]*$"
                            ErrorMessage="PA sistólica inválida: solo números positivos." />
                        <asp:RegularExpressionValidator ID="revPaDia" runat="server"
                            ControlToValidate="txtPaDiastolica"
                            CssClass="text-danger"
                            Display="Dynamic"
                            ValidationExpression="^[0-9]*$"
                            ErrorMessage="PA diastólica inválida: solo números positivos." />
                    </div>

                    <!-- SpO2 -->
                    <div class="col-md-3">
                        <label class="form-label">Saturación O₂ (SpO₂)</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtSpo2" runat="server"
                                CssClass="form-control"
                                MaxLength="3"
                                oninput="limitarEnteroPositivo(this)" />
                            <span class="input-group-text">%</span>
                        </div>
                        <asp:RegularExpressionValidator ID="revSpo2" runat="server"
                            ControlToValidate="txtSpo2"
                            CssClass="text-danger"
                            Display="Dynamic"
                            ValidationExpression="^[0-9]*$"
                            ErrorMessage="SpO₂ inválida: solo números positivos." />
                    </div>

                    <!-- Glucemia -->
                    <div class="col-md-3">
                        <label class="form-label">Glucemia capilar</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtGlucemia" runat="server"
                                CssClass="form-control"
                                MaxLength="3"
                                oninput="limitarEnteroPositivo(this)" />
                            <span class="input-group-text">mg/dL</span>
                        </div>
                        <small class="text-muted">Opcional, si aplica.</small>
                        <asp:RegularExpressionValidator ID="revGlucemia" runat="server"
                            ControlToValidate="txtGlucemia"
                            CssClass="text-danger"
                            Display="Dynamic"
                            ValidationExpression="^[0-9]*$"
                            ErrorMessage="Glucemia inválida: solo números positivos." />
                    </div>

                    <!-- Glasgow -->
                    <div class="col-md-3">
                        <label class="form-label">Glasgow</label>
                        <div class="input-group">
                            <asp:TextBox ID="txtGlasgow" runat="server"
                                CssClass="form-control"
                                MaxLength="2"
                                oninput="limitarEnteroPositivo(this)" />
                            <span class="input-group-text">/15</span>
                        </div>
                        <small class="text-muted">Opcional, si aplica.</small>
                        <asp:RegularExpressionValidator ID="revGlasgow" runat="server"
                            ControlToValidate="txtGlasgow"
                            CssClass="text-danger"
                            Display="Dynamic"
                            ValidationExpression="^[0-9]*$"
                            ErrorMessage="Glasgow inválido: solo números positivos." />
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
                            CssClass="triage-list"
                            RepeatLayout="UnorderedList">
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

    <%-- Para que los signos vitales acepten solo números positivos y no escribir texto ni símbolos--%>

    <script>

        // Solo enteros positivos (permite vacío)
        function limitarEnteroPositivo(input) {
            input.value = input.value.replace(/[^0-9]/g, '');
        }

        // Decimal positivo (permite vacío y / o . como separador)
        function limitarDecimalPositivo(input) {
            // solo dígitos, coma o punto
            let v = input.value.replace(/[^0-9.,]/g, '');

            // si hay más de una coma/punto, dejamos solo la primera
            const primera = v.search(/[.,]/);
            if (primera !== -1) {
                let entera = v.substring(0, primera + 1);
                let resto = v.substring(primera + 1).replace(/[.,]/g, '');
                v = entera + resto;
            }

            input.value = v;
        }

    </script>

</asp:Content>
