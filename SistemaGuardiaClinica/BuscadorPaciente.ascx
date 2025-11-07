<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="BuscadorPaciente.ascx.cs" Inherits="SistemaGuardiaClinica.BuscadorPaciente" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<div class="card mb-3">
    <div class="card-header">
        <h5 class="card-title mb-0">
            <i class="fas fa-search"></i> Buscar Paciente
        </h5>
    </div>
    <div class="card-body">
        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label">DNI</label>
                <asp:TextBox ID="txtDNIBuscar" runat="server" CssClass="form-control" 
                    placeholder="Ingrese DNI"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label">Apellido</label>
                <asp:TextBox ID="txtApellidoBuscar" runat="server" CssClass="form-control" 
                    placeholder="Ingrese apellido"></asp:TextBox>
            </div>
        </div>
        <div class="mt-3">
            <asp:Button ID="btnBuscar" runat="server" Text="Buscar" 
                CssClass="btn btn-primary" OnClick="btnBuscar_Click" />
        </div>
        
        <asp:GridView ID="gvResultados" runat="server" CssClass="table table-striped mt-3" 
            AutoGenerateColumns="false" Visible="false" OnRowCommand="gvResultados_RowCommand">
            <Columns>
                <asp:BoundField DataField="DNI" HeaderText="DNI" />
                <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                <asp:BoundField DataField="Apellido" HeaderText="Apellido" />
                <asp:BoundField DataField="FechaNacimiento" HeaderText="Fecha Nac." DataFormatString="{0:dd/MM/yyyy}" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btnSeleccionar" runat="server" Text="Seleccionar" 
                            CommandName="Seleccionar" CommandArgument='<%# Eval("Id") %>' 
                            CssClass="btn btn-sm btn-success" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</div>
</asp:Content>