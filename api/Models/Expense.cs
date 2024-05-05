using System.ComponentModel.DataAnnotations.Schema;

namespace api.Models
{
    [Table("expenses")]
    public class Expense
    {
        public int Id { get; set; }
        public User? UserId { get; set; }
        public string? Name { get; set; }
        public decimal Amount { get; set; }
        public DateTime Date { get; set; }
    }
}