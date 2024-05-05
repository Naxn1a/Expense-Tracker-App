using System.ComponentModel.DataAnnotations.Schema;

namespace api.Models
{
    [Table("users")]
    public class User
    {
        public int Id { get; set; }
        public string? Username { get; set; }
        public string? Password { get; set; }
    }
}