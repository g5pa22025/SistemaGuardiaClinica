using System.Collections.Generic;
using System.Linq; // <-- Para .Where(), .FirstOrDefault(), etc.
using Entidades;
using System.Data.Entity; // <-- Para .Include()

namespace Datos.Repositorios
{
    public class GuardiaRepository
    {
        private readonly ClinicaContext _context;

        public GuardiaRepository()
        {
            _context = new ClinicaContext();
        }

        public void Agregar(Guardia guardia)
        {
            _context.Guardias.Add(guardia);
            _context.SaveChanges();
        }

        public void Actualizar(Guardia guardia)
        {
            var existente = _context.Guardias.Find(guardia.Id);
            if (existente != null)
            {
                _context.Entry(existente).CurrentValues.SetValues(guardia);
                _context.SaveChanges();
            }
        }

        public Guardia ObtenerPorId(int id)
        {
            return _context.Guardias
                .Include(g => g.Paciente)
                .Include(g => g.Recepcionista)
                .Include(g => g.Enfermero)
                .Include(g => g.Medico)
                .FirstOrDefault(g => g.Id == id);
        }

        // Los más críticos aparezcan primero.
        public List<Guardia> ObtenerPorEstado(string estado)
        {
            return _context.Guardias
            .Include(g => g.Paciente)
            .Where(g => g.Estado == estado)
            .OrderBy(g => g.PrioridadFinal ?? int.MaxValue)   // 1 primero
            .ThenBy(g => g.FechaIngreso)
            .ToList();
        }

        // Los más críticos aparezcan primero.
        public List<Guardia> ObtenerPorMedico(int medicoId)
        {
            return _context.Guardias
            .Include(g => g.Paciente)
            .Where(g => g.MedicoId == medicoId && g.Estado == "Atencion")
            .OrderBy(g => g.PrioridadFinal ?? int.MaxValue)
            .ThenBy(g => g.FechaIngreso)
            .ToList();
        }

        public Guardia ObtenerPorPaciente(int pacienteId)
        {
            return _context.Guardias
                .Include(g => g.Paciente)
                .FirstOrDefault(g => g.PacienteId == pacienteId &&
                                   (g.Estado == "Espera" || g.Estado == "Triaje" || g.Estado == "Atencion"));
        }

        public List<Guardia> ObtenerTodos()
        {
            return _context.Guardias
                .Include(g => g.Paciente)
                .Include(g => g.Medico)
                .OrderByDescending(g => g.FechaIngreso)
                .ToList();
        }
    }
}