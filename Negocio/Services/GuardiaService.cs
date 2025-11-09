using System;
using System.Collections.Generic;
using Entidades;
using Datos.Repositorios;

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
                guardia.Estado = "Triaje";

                _repository.Actualizar(guardia);
            }
        }

        public void FinalizarAtencion(int guardiaId, string diagnostico, string medicamentos)
        {
            var guardia = _repository.ObtenerPorId(guardiaId);
            if (guardia != null)
            {
                guardia.DiagnosticoMedico = diagnostico;
                guardia.Medicamentos = medicamentos;
                guardia.Estado = "Finalizado";

                _repository.Actualizar(guardia);
            }
        }

        public List<Guardia> ObtenerPacientesEnEspera()
        {
            return _repository.ObtenerPorEstado("Espera");
        }

        public List<Guardia> ObtenerPacientesEnTriaje()
        {
            return _repository.ObtenerPorEstado("Triaje");
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