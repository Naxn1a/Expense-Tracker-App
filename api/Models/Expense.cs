using System.ComponentModel.DataAnnotations.Schema;

namespace api.Models
{
    [Table("expenses")]
    public class Expense
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public decimal Amount { get; set; }
        public DateTime Date { get; set; }
        public int UserId { get; set; }
        public User User { get; set; } = null!;
    }
}