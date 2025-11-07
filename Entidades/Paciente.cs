using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Entidades
{
    [Table("Pacientes")]
    public class Paciente
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "DNI obligatorio")]
        [StringLength(8, ErrorMessage = "Máximo 8 caracteres")]
        public string DNI { get; set; }

        [Required(ErrorMessage = "Nombre obligatorio")]
        [StringLength(100)]
        public string Nombre { get; set; }

        [Required(ErrorMessage = "Apellido obligatorio")]
        [StringLength(100)]
        public string Apellido { get; set; }

        [Required(ErrorMessage = "Fecha de nacimiento obligatoria")]
        public DateTime FechaNacimiento { get; set; }

        [Required(ErrorMessage = "Género obligatorio")]
        public string Genero { get; set; }

        public string Telefono { get; set; }

        [EmailAddress]
        public string Email { get; set; }

        public string Direccion { get; set; }

        public string ObraSocial { get; set; }

        public string NumeroAfiliado { get; set; }

        [Required(ErrorMessage = "Prioridad obligatoria")]
        [Range(1, 5, ErrorMessage = "La prioridad debe estar entre 1 y 5")]
        public int Prioridad { get; set; }

        public string Estado { get; set; }
    }
}