using System;
using System.Collections.Generic;
using System.Linq;
using Datos;               
using Entidades;          
using System.Data.Entity;
using Datos.Repositorios; 

namespace Negocio.Services
{
    public class PacienteService
    {
        private readonly PacienteRepository _repository;

        public PacienteService()
        {
            _repository = new PacienteRepository();
        }

        public void CrearPaciente(Paciente paciente)
        {
            // Validar que el DNI no exista
            var existente = _repository.ObtenerPorDNI(paciente.DNI);
            if (existente != null)
                throw new System.Exception("Ya existe un paciente con este DNI");

            _repository.Agregar(paciente);
        }

        public void ActualizarPaciente(Paciente paciente)
        {
            _repository.Actualizar(paciente);
        }

        public void EliminarPaciente(int id)
        {
            _repository.Eliminar(id);
        }

        public Paciente ObtenerPaciente(int id)
        {
            return _repository.ObtenerPorId(id);
        }

        public Paciente BuscarPorDNI(string dni)
        {
            return _repository.ObtenerPorDNI(dni);
        }

        public List<Paciente> BuscarPacientes(string dni, string apellido)
        {
            return _repository.Buscar(dni, apellido);
        }

        public List<Paciente> BuscarPorDniOApellido(string dni, string apellido)
        {
            dni = (dni ?? "").Trim();
            apellido = (apellido ?? "").Trim();

            using (var ctx = new ClinicaContext())
            {
                var q = ctx.Pacientes.AsQueryable();

                // Si no llega nada, devolvemos todo
                if (string.IsNullOrEmpty(dni) && string.IsNullOrEmpty(apellido))
                    return q.OrderBy(p => p.Apellido).ThenBy(p => p.Nombre).ToList();

                // Normalizamos solo para case-insensitive (acentos dependen de la collation de la DB)
                var apeLower = (apellido ?? "").ToLower();

                if (!string.IsNullOrEmpty(dni) && !string.IsNullOrEmpty(apellido))
                {
                    // OR: coincide por DNI O por Apellido
                    q = q.Where(p =>
                        p.DNI.Contains(dni) ||
                        p.Apellido.ToLower().Contains(apeLower));
                }
                else if (!string.IsNullOrEmpty(dni))
                {
                    q = q.Where(p => p.DNI.Contains(dni));
                }
                else // solo apellido
                {
                    q = q.Where(p => p.Apellido.ToLower().Contains(apeLower));
                }

                return q.OrderBy(p => p.Apellido).ThenBy(p => p.Nombre).ToList();
            }
        }

        public List<Paciente> ObtenerTodos()
        {
            using (var ctx = new ClinicaContext())
            {
                return ctx.Pacientes
                          .OrderBy(p => p.Apellido).ThenBy(p => p.Nombre)
                          .ToList();
            }
        }
    }
}