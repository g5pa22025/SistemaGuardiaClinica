using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Entidades
{
    [Table("Guardias")] 
    public class Guardia
    {
        public int Id { get; set; }

        public int PacienteId { get; set; }

        [ForeignKey("PacienteId")] 
        public virtual Paciente Paciente { get; set; }

        [Required]
        public DateTime FechaIngreso { get; set; }

        public int RecepcionistaId { get; set; }

        [ForeignKey("RecepcionistaId")]
        public virtual Usuario Recepcionista { get; set; }

        public int? EnfermeroId { get; set; }

        [ForeignKey("EnfermeroId")] 
        public virtual Usuario Enfermero { get; set; }

        public int? MedicoId { get; set; }

        [ForeignKey("MedicoId")] 
        public virtual Usuario Medico { get; set; }

        public string EspecialidadRequerida { get; set; }

        public string Sintomas { get; set; }

        public string ObservacionesEnfermero { get; set; }

        public string DiagnosticoMedico { get; set; }

        public string Medicamentos { get; set; }

        public string Estado { get; set; }

        [Range(1, 5)]
        public int? PrioridadFinal { get; set; }
    }
}