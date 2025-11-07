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
    }
}