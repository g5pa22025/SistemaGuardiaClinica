using System;
using System.Data.SqlClient;
using System.Text;
using System.Web.Configuration;
using Entidades;
using Negocio.Services;

namespace SistemaGuardiaClinica
{
    public partial class TestBD : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Mostrar la connection string actual
                var connString = WebConfigurationManager.ConnectionStrings["ClinicaConnectionString"]?.ConnectionString;
                lblInfo.Text = $"<strong>Connection String actual:</strong><br/>{connString}";
            }
        }

        private void TestConexion(string connectionString, string nombre)
        {
            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    var resultado = new StringBuilder();
                    resultado.Append($"✅ <strong>{nombre}</strong> - CONEXIÓN EXITOSA<br/>");
                    resultado.Append($"• Servidor: {connection.DataSource}<br/>");
                    resultado.Append($"• Base de datos: {connection.Database}<br/>");
                    resultado.Append($"• Estado: {connection.State}<br/>");
                    resultado.Append($"• Versión: {connection.ServerVersion}<br/>");

                    lblResultado.Text = resultado.ToString();
                    lblResultado.CssClass = "alert alert-success";
                }
            }
            catch (Exception ex)
            {
                var resultado = new StringBuilder();
                resultado.Append($"❌ <strong>{nombre}</strong> - ERROR<br/>");
                resultado.Append($"• Connection String: {connectionString}<br/>");
                resultado.Append($"• Error: {ex.Message}<br/>");

                lblResultado.Text = resultado.ToString();
                lblResultado.CssClass = "alert alert-danger";
            }
        }

        protected void btnTest1_Click(object sender, EventArgs e)
        {
            TestConexion(
                "Data Source=localhost\\SQLEXPRESS;Initial Catalog=GuardiaClinicaDB;Integrated Security=True;MultipleActiveResultSets=True",
                "localhost\\\\SQLEXPRESS"
            );
        }

        protected void btnTest2_Click(object sender, EventArgs e)
        {
            TestConexion(
                "Data Source=.\\SQLEXPRESS;Initial Catalog=GuardiaClinicaDB;Integrated Security=True;MultipleActiveResultSets=True",
                ".\\\\SQLEXPRESS"
            );
        }

        protected void btnTest3_Click(object sender, EventArgs e)
        {
            TestConexion(
                "Data Source=(local)\\SQLEXPRESS;Initial Catalog=GuardiaClinicaDB;Integrated Security=True;MultipleActiveResultSets=True",
                "(local)\\\\SQLEXPRESS"
            );
        }

        protected void btnTestLogin_Click(object sender, EventArgs e)
        {
            try
            {
                var authService = new AuthService();
                var usuario = authService.Login("recepcion@clinica.com", "123456");

                if (usuario != null)
                {
                    var resultado = new StringBuilder();
                    resultado.Append($"✅ <strong>Login Exitoso con EF6</strong><br/>");
                    resultado.Append($"• Usuario: {usuario.Nombre} {usuario.Apellido}<br/>");
                    resultado.Append($"• Rol: {usuario.Rol?.Nombre}<br/>");
                    resultado.Append($"• Email: {usuario.Email}<br/>");
                    resultado.Append($"• Especialidad: {usuario.Especialidad ?? "N/A"}<br/>");

                    lblResultado.Text = resultado.ToString();
                    lblResultado.CssClass = "alert alert-success";

                    Session["Usuario"] = usuario;
                }
                else
                {
                    lblResultado.Text = "❌ Login Fallido - Credenciales incorrectas o usuario no encontrado";
                    lblResultado.CssClass = "alert alert-danger";
                }
            }
            catch (Exception ex)
            {
                var resultado = new StringBuilder();
                resultado.Append($"❌ Error en Login: {ex.Message}<br/>");
                resultado.Append($"<br/><strong>Detalles:</strong><br/>");
                resultado.Append($"{ex.InnerException?.Message}<br/>");

                lblResultado.Text = resultado.ToString();
                lblResultado.CssClass = "alert alert-danger";
            }
        }

        protected void btnVerTablas_Click(object sender, EventArgs e)
        {
            try
            {
                var connectionString = WebConfigurationManager.ConnectionStrings["ClinicaConnectionString"]?.ConnectionString;
                if (string.IsNullOrEmpty(connectionString))
                {
                    lblResultado.Text = "❌ No se encontró connection string en Web.config";
                    lblResultado.CssClass = "alert alert-danger";
                    return;
                }

                var resultado = new StringBuilder();

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    // Verificar tablas existentes
                    string query = @"
                        SELECT TABLE_NAME, TABLE_TYPE 
                        FROM INFORMATION_SCHEMA.TABLES 
                        WHERE TABLE_TYPE = 'BASE TABLE'
                        ORDER BY TABLE_NAME";

                    using (var command = new SqlCommand(query, connection))
                    using (var reader = command.ExecuteReader())
                    {
                        resultado.Append("📊 <strong>Tablas en la base de datos:</strong><br/>");
                        while (reader.Read())
                        {
                            resultado.Append($"• {reader["TABLE_NAME"]}<br/>");
                        }
                    }

                    resultado.Append("<br/>");

                    // Contar registros en cada tabla
                    string[] tablas = { "Roles", "Usuarios", "Pacientes", "Guardias" };
                    foreach (var tabla in tablas)
                    {
                        try
                        {
                            string countQuery = $"SELECT COUNT(*) as Cantidad FROM {tabla}";
                            using (var command = new SqlCommand(countQuery, connection))
                            {
                                int cantidad = (int)command.ExecuteScalar();
                                resultado.Append($"📈 <strong>{tabla}:</strong> {cantidad} registros<br/>");
                            }
                        }
                        catch (Exception ex)
                        {
                            resultado.Append($"❌ <strong>{tabla}:</strong> No existe - {ex.Message}<br/>");
                        }
                    }
                }

                lblResultado.Text = resultado.ToString();
                lblResultado.CssClass = "alert alert-info";
            }
            catch (Exception ex)
            {
                lblResultado.Text = $"❌ Error verificando tablas: {ex.Message}";
                lblResultado.CssClass = "alert alert-danger";
            }
        }
    }
}