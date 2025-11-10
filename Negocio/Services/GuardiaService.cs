using Datos;
using Datos.Repositorios;
using Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;   // Para Include

namespace Negocio.Services
{
    public class GuardiaService
    {
        private readonly GuardiaRepository _repository;
        private readonly UsuarioRepository _usuarioRepository;

        public GuardiaService()
        {
            _repository = new GuardiaRepository();
            _usuarioRepository = new UsuarioRepository();
        }

        public void IniciarGuardia(Paciente paciente, int recepcionistaId, string sintomas)
        {
            var guardia = new Guardia
            {
                PacienteId = paciente.Id,
                FechaIngreso = DateTime.Now,
                RecepcionistaId = recepcionistaId,
                Sintomas = sintomas,
                Estado = "Espera"
            };

            _repository.Agregar(guardia);
        }

        public void RealizarTriaje(int guardiaId, int enfermeroId, string observaciones, int prioridad, string especialidadRequerida)
        {
            var guardia = _repository.ObtenerPorId(guardiaId);
            if (guardia != null)
            {
                guardia.EnfermeroId = enfermeroId;
                guardia.ObservacionesEnfermero = observaciones;
                guardia.PrioridadFinal = prioridad;
                guardia.EspecialidadRequerida = especialidadRequerida;
                guardia.Estado = "Triaje";

                _repository.Actualizar(guardia);
            }
        }

        public void AsignarMedico(int guardiaId, int medicoId)
        {
            var guardia = _repository.ObtenerPorId(guardiaId);
            if (guardia != null)
            {
                guardia.MedicoId = medicoId;
                guardia.Estado = "Triaje";  // o "En consulta" 

                _repository.Actualizar(guardia);
            }
        }

        // Finaliza la atención médica, dejando Estado = "Atendido".
        public void FinalizarAtencion(int guardiaId, int medicoId, string diagnostico, string medicamentos)
        {
            var g = _repository.ObtenerPorId(guardiaId);
            if (g == null)
                throw new Exception("Guardia no encontrada.");

            g.DiagnosticoMedico = diagnostico;
            g.Medicamentos = medicamentos;
            g.MedicoId = medicoId;
            g.Estado = "Atendido";

            _repository.Actualizar(g);
        }

        public List<Guardia> ObtenerPacientesEnEspera()
        {
            return _repository.ObtenerPorEstado("Espera");
        }

        /// <summary>
        /// Pacientes triageados (y también atendidos, para que sigan visibles).
        /// </summary>
        public IList<Guardia> ObtenerPacientesEnTriaje()
        {
            using (var ctx = new ClinicaContext())
            {
                return ctx.Guardias
                    .Include(g => g.Paciente)
                    .Where(g => g.Estado == "Triaje" || g.Estado == "Atendido")
                    .OrderBy(g => g.PrioridadFinal)
                    .ThenBy(g => g.FechaIngreso)
                    .ToList();
            }
        }

        public IList<Guardia> ObtenerPacientesEnTriajePorEspecialidad(string especialidadRequerida, int? medicoId = null)
        {
            using (var ctx = new ClinicaContext())
            {
                var q = ctx.Guardias
                    .Include("Paciente")
                    .Where(g => g.Estado == "Triaje" || g.Estado == "Atendido");

                if (!string.IsNullOrWhiteSpace(especialidadRequerida))
                    q = q.Where(g => g.EspecialidadRequerida == especialidadRequerida);

                if (medicoId.HasValue && medicoId.Value > 0)
                    q = q.Where(g => g.MedicoId == null || g.MedicoId == medicoId.Value);

                return q
                    .OrderBy(g => g.PrioridadFinal)
                    .ThenBy(g => g.FechaIngreso)
                    .ToList();
            }
        }

        public List<Guardia> ObtenerPacientesPorMedico(int medicoId)
        {
            return _repository.ObtenerPorMedico(medicoId);
        }

        public List<Usuario> ObtenerMedicosDisponibles(string especialidad)
        {
            return _usuarioRepository.ObtenerMedicosPorEspecialidad(especialidad);
        }
    }
}