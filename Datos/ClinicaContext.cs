using System.Data.Entity;
using Entidades;
using System.ComponentModel.DataAnnotations.Schema;

namespace Datos
{
    public class ClinicaContext : DbContext
    {
        public ClinicaContext() : base("name=ClinicaConnectionString")
        {
            // Configuración para desarrollo
            Database.SetInitializer(new CreateDatabaseIfNotExists<ClinicaContext>());
            Configuration.LazyLoadingEnabled = false;
            Configuration.ProxyCreationEnabled = false;
        }

        public DbSet<Usuario> Usuarios { get; set; }
        public DbSet<Rol> Roles { get; set; }
        public DbSet<Paciente> Pacientes { get; set; }
        public DbSet<Guardia> Guardias { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            // Configurar nombres de tablas explícitamente
            modelBuilder.Entity<Usuario>().ToTable("Usuarios");
            modelBuilder.Entity<Rol>().ToTable("Roles");
            modelBuilder.Entity<Paciente>().ToTable("Pacientes");
            modelBuilder.Entity<Guardia>().ToTable("Guardias");

            // Configurar claves foráneas
            modelBuilder.Entity<Usuario>()
                .HasRequired(u => u.Rol)
                .WithMany()
                .HasForeignKey(u => u.RolId)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Guardia>()
                .HasRequired(g => g.Paciente)
                .WithMany()
                .HasForeignKey(g => g.PacienteId)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Guardia>()
                .HasRequired(g => g.Recepcionista)
                .WithMany()
                .HasForeignKey(g => g.RecepcionistaId)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Guardia>()
                .HasOptional(g => g.Enfermero)
                .WithMany()
                .HasForeignKey(g => g.EnfermeroId)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Guardia>()
                .HasOptional(g => g.Medico)
                .WithMany()
                .HasForeignKey(g => g.MedicoId)
                .WillCascadeOnDelete(false);

            base.OnModelCreating(modelBuilder);
        }
    }
}