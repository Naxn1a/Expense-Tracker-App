using System.Security.Claims;
using api.Contexts;
using api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly ApiDbContext _context;

        public UserController(ApiDbContext context)
        {
            _context = context;
        }

        [HttpGet] // Get all users
        public async Task<ActionResult<IEnumerable<User>>> GetUsers()
        {
            return await _context.Users.ToListAsync();
        }

        [HttpGet("{id}")] // Get a user by id
        public async Task<ActionResult<User>> GetUser(int id)
        {
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return NotFound();
            }

            return Ok(user);
        }

        [HttpPost("signup")] // Create a new user
        public async Task<ActionResult<User>> SignUp(User user)
        {
            string hashedPassword = BCrypt.Net.BCrypt.HashPassword(user.Password);

            _context.Users.Add(new User
            {
                Username = user.Username,
                Password = hashedPassword
            });

            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetUser), new { id = user.Id }, user);
        }

        [HttpPost("signin")] // Sign in
        public async Task<ActionResult<User>> SignIn(User user)
        {
            var userInDb = await _context.Users.FirstOrDefaultAsync(u => u.Username == user.Username);

            if (userInDb == null)
            {
                return NotFound();
            }

            if (!BCrypt.Net.BCrypt.Verify(user.Password, userInDb.Password))
            {
                return Unauthorized();
            }

            return Ok(userInDb);
        }

        [HttpDelete("{id}")] // Delete a user
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return NotFound();
            }

            _context.Users.Remove(user);

            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}