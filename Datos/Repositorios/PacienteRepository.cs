using System.Collections.Generic;
using System.Linq;
using Entidades;

namespace Datos.Repositorios
{
    public class PacienteRepository
    {
        private readonly ClinicaContext _context;

        public PacienteRepository()
        {
            _context = new ClinicaContext();
        }

        public void Agregar(Paciente paciente)
        {
            _context.Pacientes.Add(paciente);
            _context.SaveChanges();
        }

        public void Actualizar(Paciente paciente)
        {
            var existente = _context.Pacientes.Find(paciente.Id);
            if (existente != null)
            {
                _context.Entry(existente).CurrentValues.SetValues(paciente);
                _context.SaveChanges();
            }
        }

        public void Eliminar(int id)
        {
            var paciente = _context.Pacientes.Find(id);
            if (paciente != null)
            {
                _context.Pacientes.Remove(paciente);
                _context.SaveChanges();
            }
        }

        public Paciente ObtenerPorId(int id)
        {
            return _context.Pacientes.Find(id);
        }

        public Paciente ObtenerPorDNI(string dni)
        {
            return _context.Pacientes.FirstOrDefault(p => p.DNI == dni);
        }

        public List<Paciente> ObtenerTodos()
        {
            return _context.Pacientes.ToList();
        }

        public List<Paciente> Buscar(string dni, string apellido)
        {
            var query = _context.Pacientes.AsQueryable();

            if (!string.IsNullOrEmpty(dni))
                query = query.Where(p => p.DNI.Contains(dni));

            if (!string.IsNullOrEmpty(apellido))
                query = query.Where(p => p.Apellido.Contains(apellido));

            return query.ToList();
        }
    }
}