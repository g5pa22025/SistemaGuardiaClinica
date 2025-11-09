<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Triage.aspx.cs"
    Inherits="SistemaGuardiaClinica.Enfermeria.Triage"
    MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Bootstrap Icons (Bootstrap ya viene desde el master) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <style>
        body { background: #f6f8fb; }
        .card { border-radius: 1rem; }
        .table td, .table th { vertical-align: middle; }
        .row-pr-1 { --bs-table-bg: #fdecea; } /* Rojo suave - P1 (Inmediato) */
        .row-pr-2 { --bs-table-bg: #fff3cd; } /* Naranja suave - P2 (Muy urgente) */
        .row-pr-3 { --bs-table-bg: #fff7e6; } /* Amarillo suave - P3 (Urgente) */
        .row-pr-4 { --bs-table-bg: #edf7ee; } /* Verde suave - P4 (Menos urgente) */
        .row-pr-5 { --bs-table-bg: #e7f1ff; } /* Azul suave - P5 (No urgente) */
        .bg-prio-orange { background-color: #fd7e14 !important; } /* Naranja Bootstrap-like */
    </style>

    <div class="container py-4">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h4 class="mb-0">
                <i class="bi bi-clipboard-pulse me-2"></i> Pacientes en espera
            </h4>
        </div>

        <asp:PlaceHolder ID="phMsg" runat="server"></asp:PlaceHolder>

        <asp:Repeater ID="rpEspera" runat="server">
            <HeaderTemplate>
                <div class="card shadow-sm">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Fecha Ingreso</th>
                                    <th>DNI</th>
                                    <th>Paciente</th>
                                    <th>Síntomas</th>
                                    <th style="width: 130px;">Prioridad</th>
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
                    <td class="text-end align-middle">
                    <!-- Abrir Triage -->
                    <a runat="server"
                        href='<%# ResolveUrl("~/Enfermeria/TriageDetalle.aspx?id=" + Eval("Id")) %>'
                        class="btn btn-sm btn-primary me-2"
                        data-bs-toggle="tooltip"
                        data-bs-placement="top"
                        title="Comenzar Triaje">
                        <i class="bi bi-box-arrow-up-right me-1"></i> Abrir Triage
                    </a>

                        <!-- Info (modal) -->
                        <button type="button"
                            class="btn btn-sm btn-outline-info"
                            title="Ver resumen de triage"
                            data-bs-toggle="modal"
                            data-bs-target="#modalInfoTriage"
                            data-paciente='<%# (Eval("Paciente.Apellido") + ", " + Eval("Paciente.Nombre")).ToString().Replace("\"","\\\"") %>'
                            data-dni='<%# Eval("Paciente.DNI") %>'
                            data-fecha='<%# Eval("FechaIngreso", "{0:dd/MM/yyyy HH:mm}") %>'
                            data-sintomas='<%# (Eval("Sintomas") ?? "").ToString().Replace("\"","\\\"") %>'
                            data-prioridad='<%# (Eval("PrioridadFinal") ?? 0) %>'
                            data-color='<%# (Eval("NivelUrgenciaColor") ?? "").ToString() %>'
                            data-especialidad='<%# (Eval("EspecialidadRequerida") ?? "").ToString().Replace("\"","\\\"") %>'
                            data-obs='<%# (Eval("ObservacionesEnfermero") ?? "").ToString().Replace("\"","\\\"") %>'>
                            <i class="bi bi-info-circle me-1"></i> Info
                        </button>

                       <!-- Editar síntomas/prioridad: abre modal -->
                        <button type="button"
                            class="btn btn-sm btn-outline-secondary"
                            title="Editar síntomas y prioridad"
                            onclick='openEditModal(
                                "<%# Eval("Id") %>",
                                "<%# (Eval("Paciente.Apellido") + ", " + Eval("Paciente.Nombre")).ToString() %>",
                                "<%# (Eval("Sintomas") ?? "").ToString() %>",
                                "<%# (Eval("PrioridadFinal") ?? 1) %>"
                            )'>
                            <i class="bi bi-pencil-square me-1"></i> Editar
                        </button>
                        </div>
                    </td>
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

    <!-- Hidden fields para modal -->
    <asp:HiddenField ID="hfEditGuardiaId" runat="server" />
    <asp:HiddenField ID="hfEditPrioridad" runat="server" />

    <!-- MODAL editar síntomas/prioridad -->
    <div class="modal fade" id="modalEdit" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header bg-secondary text-white">
            <h5 class="modal-title">
              <i class="bi bi-pencil-square me-2"></i> Editar síntomas y prioridad
            </h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
          </div>

          <div class="modal-body">
            <div class="alert alert-info">
              <strong>Paciente:</strong> <span id="editPacienteNombre"></span>
            </div>

            <div class="mb-3">
              <label class="form-label">¿Cambió algo en sus síntomas?</label>
              <div class="form-text">Si cambió, actualizá la descripción. Si no, podés confirmar sin cambios.</div>
            </div>

            <div class="mb-3">
              <label class="form-label">Síntomas / descripción</label>
              <asp:TextBox ID="txtEditSintomas" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"
                           placeholder="Escribí lo que te cuenta el paciente..."></asp:TextBox>
            </div>

            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label">Prioridad</label>
                <asp:DropDownList ID="ddlEditPrioridad" runat="server" CssClass="form-select"
                  onchange="onPriorityChange(this.value)">
                    <asp:ListItem Value="1">P1 (Inmediato)</asp:ListItem>
                    <asp:ListItem Value="2">P2 (Muy urgente)</asp:ListItem>
                    <asp:ListItem Value="3">P3 (Urgente)</asp:ListItem>
                    <asp:ListItem Value="4">P4 (Menos urgente)</asp:ListItem>
                    <asp:ListItem Value="5">P5 (No urgente)</asp:ListItem>
                </asp:DropDownList>

              </div>
              <div class="col-md-6 d-flex align-items-end">
                <span>Vista previa:&nbsp;</span>
                <span id="prioPreview" class="badge rounded-pill bg-secondary px-3 py-2">–</span>
              </div>
            </div>
          </div>

          <div class="modal-footer flex-column flex-sm-row gap-2">
            <asp:Button ID="btnGuardarEdicion" runat="server" CssClass="btn btn-secondary px-4"
                        Text="Guardar cambios" OnClick="btnGuardarEdicion_Click" />
            <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Cancelar</button>
          </div>
        </div>
      </div>
    </div>

    <!-- MODAL INFO TRIAGE -->
<div class="modal fade" id="modalInfoTriage" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header bg-info text-white">
        <h5 class="modal-title">
          <i class="bi bi-info-circle me-2"></i> Resumen de triage
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <div class="modal-body">
        <div class="mb-3">
          <strong>Paciente:</strong> <span id="infoPaciente"></span><br />
          <strong>DNI:</strong> <span id="infoDni"></span><br />
          <strong>Fecha ingreso:</strong> <span id="infoFecha"></span>
        </div>

        <hr />

        <div class="mb-3">
          <strong>Síntomas iniciales:</strong>
          <p class="mb-0" id="infoSintomas"></p>
        </div>

        <div class="row g-3 mb-3">
          <div class="col-md-4">
            <strong>Prioridad final:</strong>
            <span id="infoPrioridad" class="badge rounded-pill bg-secondary ms-1"></span>
          </div>
          <div class="col-md-4">
            <strong>Color / nivel:</strong>
            <span id="infoColor"></span>
          </div>
          <div class="col-md-4">
            <strong>Especialidad requerida:</strong>
            <span id="infoEspecialidad"></span>
          </div>
        </div>

        <div class="mb-3">
          <strong>Observaciones de enfermería:</strong>
          <p class="mb-0" id="infoObs"></p>
        </div>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cerrar</button>
      </div>
    </div>
  </div>
</div>

    <!-- Scripts propios de esta página (Bootstrap JS ya viene del master) -->
    <script>

        //Mapeo de colores para las prioridades
        function priorityClass(p) {
            p = parseInt(p || 0);

            switch (p) {
                case 1: return "bg-danger";       // Rojo - Inmediato
                case 2: return "bg-prio-orange";  // Naranja - Muy urgente
                case 3: return "bg-warning";      // Amarillo - Urgente
                case 4: return "bg-success";      // Verde - Menos urgente
                case 5: return "bg-primary";      // Azul - No urgente
                default: return "bg-secondary";   // Sin definir
            }
        }

        function onPriorityChange(p) {
            var badge = document.getElementById("prioPreview");
            badge.className = "badge rounded-pill px-3 py-2 " + priorityClass(p);
            badge.innerText = "P" + p;
            document.getElementById("<%= hfEditPrioridad.ClientID %>").value = p;
        }

        // Abre modal de edición y setea datos
        function openEditModal(guardiaId, nombre, sintomas, prioridad) {
            document.getElementById("<%= hfEditGuardiaId.ClientID %>").value = guardiaId;
            document.getElementById("editPacienteNombre").innerText = nombre;

            // set síntomas
            document.getElementById("<%= txtEditSintomas.ClientID %>").value = sintomas || "";

            // set prioridad
            var ddl = document.getElementById("<%= ddlEditPrioridad.ClientID %>");
            ddl.value = prioridad || "1";
            onPriorityChange(ddl.value);

            new bootstrap.Modal(document.getElementById('modalEdit')).show();
        }


        // Inicializar tooltips de Bootstrap
        document.addEventListener('DOMContentLoaded', function () {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.forEach(function (el) {
                new bootstrap.Tooltip(el);
            });
        });

        // Helper para mostrar "P1, P2..." con color de badge


        //Al hacer clic en Info, Bootstrap lanza el evento show.bs.modal
        //El script lee los data-* del botón que disparó el modal
        //Llena los <span> y <p> del modal con los datos de esa guardia.

        function prioridadBadgeClass(p) {
            p = parseInt(p || 0);
            switch (p) {
                case 1: return "bg-danger";       // Rojo
                case 2: return "bg-prio-orange";  // Naranja
                case 3: return "bg-warning";      // Amarillo
                case 4: return "bg-success";      // Verde
                case 5: return "bg-primary";      // Azul
                default: return "bg-secondary";
            }
        }

        document.addEventListener('DOMContentLoaded', function () {
            var infoModal = document.getElementById('modalInfoTriage');
            if (!infoModal) return;

            infoModal.addEventListener('show.bs.modal', function (event) {
                var button = event.relatedTarget;
                if (!button) return;

                var paciente = button.getAttribute('data-paciente') || '';
                var dni = button.getAttribute('data-dni') || '';
                var fecha = button.getAttribute('data-fecha') || '';
                var sintomas = button.getAttribute('data-sintomas') || '';
                var prioridad = button.getAttribute('data-prioridad') || '';
                var color = button.getAttribute('data-color') || '';
                var especialidad = button.getAttribute('data-especialidad') || '';
                var obs = button.getAttribute('data-obs') || '';

                document.getElementById('infoPaciente').innerText = paciente;
                document.getElementById('infoDni').innerText = dni;
                document.getElementById('infoFecha').innerText = fecha;
                document.getElementById('infoSintomas').innerText = sintomas || '—';
                document.getElementById('infoObs').innerText = obs || '—';
                document.getElementById('infoEspecialidad').innerText = especialidad || '—';

                var prioBadge = document.getElementById('infoPrioridad');
                prioBadge.className = 'badge rounded-pill ms-1 ' + prioridadBadgeClass(prioridad);
                prioBadge.innerText = prioridad ? ('P' + prioridad) : '—';

                var colorDescripcion;
                switch (parseInt(prioridad || 0)) {
                    case 1:
                        colorDescripcion = "Rojo – Emergencia (atención inmediata)";
                        break;
                    case 2:
                        colorDescripcion = "Naranja – Muy urgente";
                        break;
                    case 3:
                        colorDescripcion = "Amarillo – Urgente (< 30 min)";
                        break;
                    case 4:
                        colorDescripcion = "Verde – Menos urgente";
                        break;
                    case 5:
                        colorDescripcion = "Azul – No urgente / administrativa";
                        break;
                    default:
                        colorDescripcion = color || "—";
                        break;
                }

                document.getElementById('infoColor').innerText = colorDescripcion;
            });
        });

    </script>

</asp:Content>