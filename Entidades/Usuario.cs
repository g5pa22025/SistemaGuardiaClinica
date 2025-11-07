using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Entidades
{
    [Table("Usuarios")]
    public class Usuario
    {
        public int Id { get; set; }

        [Required]
        [StringLength(10)]
        public string DNI { get; set; }

        [Required]
        [StringLength(100)]
        public string Nombre { get; set; }

        [Required]
        [StringLength(100)]
        public string Apellido { get; set; }

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        public string Password { get; set; }

        public int RolId { get; set; }

        [ForeignKey("RolId")] 
        public virtual Rol Rol { get; set; }

        [StringLength(50)]
        public string Especialidad { get; set; }

        public bool Activo { get; set; }
    }
}