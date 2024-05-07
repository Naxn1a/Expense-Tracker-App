using api.Models;
using Microsoft.EntityFrameworkCore;

namespace api.Context
{
    public class ApiDbContext : DbContext
    {
        public ApiDbContext(DbContextOptions<ApiDbContext> options) : base(options) { }
        
        public DbSet<User> Users { get; set; } = null!;
    }
}