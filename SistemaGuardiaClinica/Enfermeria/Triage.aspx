<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Triage.aspx.cs"
    Inherits="SistemaGuardiaClinica.Enfermeria.Triage" %>

<!DOCTYPE html>
<html>
<head runat="server">
  <meta charset="utf-8" />
  <title>Pacientes en espera</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <!-- Bootstrap + Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

  <style>
    body { background: #f6f8fb; }
    .card { border-radius: 1rem; }
    .table td, .table th { vertical-align: middle; }
    .row-pr-1, .row-pr-2 { --bs-table-bg: #edf7ee; }     /* verde suave */
    .row-pr-3, .row-pr-4 { --bs-table-bg: #fff7e6; }     /* amarillo suave */
    .row-pr-5 { --bs-table-bg: #fdecea; }                /* rojo suave */
  </style>
</head>
<body>
<form runat="server">

  <!-- NAVBAR con usuario y salir -->
  <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
      <a class="navbar-brand d-flex align-items-center" href="#">
        <i class="bi bi-heart-pulse me-2"></i> Enfermería
      </a>
      <div class="ms-auto d-flex align-items-center gap-3">
        <span class="text-white-50"><i class="bi bi-person-circle me-1"></i>
          <asp:Literal ID="litUsuario" runat="server" />
        </span>
        <a runat="server" href="~/Logout.aspx" class="btn btn-outline-light btn-sm">
          <i class="bi bi-box-arrow-right me-1"></i> Salir
        </a>
      </div>
    </div>
  </nav>

  <div class="container py-4">
    <div class="d-flex align-items-center justify-content-between mb-3">
      <h4 class="mb-0"><i class="bi bi-clipboard-pulse me-2"></i> Pacientes en espera</h4>
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
                  <th style="width:40%">Síntomas</th>
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
            <asp:Literal runat="server" Mode="PassThrough" Text='<%# GetBadge((int?)Eval("PrioridadFinal")) %>' />
          </td>
          <td class="text-end">
            <!-- Abrir Triage -->
            <a runat="server" href='<%# ResolveUrl("~/Enfermeria/TriageDetalle.aspx?id=" + Eval("Id")) %>'
               class="btn btn-sm btn-primary me-2">
              <i class="bi bi-box-arrow-up-right me-1"></i> Abrir Triage
            </a>

            <!-- Editar síntomas/prioridad: abre modal -->
            <button type="button" class="btn btn-sm btn-outline-secondary"
              onclick='openEditModal(
                "<%# Eval("Id") %>",
                "<%# (Eval("Paciente.Apellido") + ", " + Eval("Paciente.Nombre")).ToString().Replace("\"","\\\"") %>",
                "<%# (Eval("Sintomas") ?? "").ToString().Replace("\"","\\\"") %>",
                "<%# (Eval("PrioridadFinal") ?? 1) %>"
              )'>
              <i class="bi bi-pencil-square me-1"></i> Editar
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
                <asp:ListItem Value="1">P1 (Baja)</asp:ListItem>
                <asp:ListItem Value="2">P2 (Baja)</asp:ListItem>
                <asp:ListItem Value="3">P3 (Media)</asp:ListItem>
                <asp:ListItem Value="4">P4 (Alta)</asp:ListItem>
                <asp:ListItem Value="5">P5 (Crítica)</asp:ListItem>
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

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

  <script>
    function priorityClass(p) {
      p = parseInt(p || 0);
      if (p <= 2) return "bg-success";
      if (p <= 4) return "bg-warning";
      return "bg-danger";
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
  </script>

</form>
</body>
</html>