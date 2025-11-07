using Entidades;
using Datos.Repositorios;

namespace Negocio.Services
{
    public class AuthService
    {
        private readonly UsuarioRepository _repository;

        public AuthService()
        {
            _repository = new UsuarioRepository();
        }

        public Usuario Login(string email, string password)
        {
            return _repository.ValidarLogin(email, password);
        }

        public bool TieneAcceso(string rolRequerido, Usuario usuario)
        {
            return usuario?.Rol?.Nombre == rolRequerido;
        }
    }
}