using api.Models;
using Microsoft.EntityFrameworkCore;

namespace api.Contexts
{
    public class ApiDbContext : DbContext
    {
        public ApiDbContext(DbContextOptions<ApiDbContext> options) : base(options) { }

        public DbSet<User> Users { get; set; }
    }
}