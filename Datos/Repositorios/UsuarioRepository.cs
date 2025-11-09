using System.Collections.Generic;
using System.Linq;
using Entidades;
using System.Data.Entity;

namespace Datos.Repositorios
{
    public class UsuarioRepository
    {
        private readonly ClinicaContext _context;

        public UsuarioRepository()
        {
            _context = new ClinicaContext();
        }

        public Usuario ValidarLogin(string email, string password)
        {
            return _context.Usuarios
                .Include(u => u.Rol)
                .FirstOrDefault(u => u.Email == email && u.Password == password && u.Activo);
        }

        public List<Usuario> ObtenerMedicosPorEspecialidad(string especialidad)
        {
            return _context.Usuarios
                .Where(u => u.RolId == 3 && u.Especialidad == especialidad && u.Activo)
                .ToList();
        }

        // Traer todos los médicos activos
        public List<Usuario> ObtenerMedicos()
        {
            return _context.Usuarios
                .Where(u => u.RolId == 3 && u.Activo)   // RolId = 3 -> Médicos
                .OrderBy(u => u.Apellido)
                .ThenBy(u => u.Nombre)
                .ToList();
        }

        public List<string> ObtenerEspecialidadesMedicas()
        {
            return _context.Usuarios
                .Where(u => u.RolId == 3 && u.Activo && u.Especialidad != null && u.Especialidad != "")
                .Select(u => u.Especialidad)
                .Distinct()
                .OrderBy(e => e)
                .ToList();
        }

    }
}