using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace _3de0_Identity.Data
{
    public class IdentityAppDbContext : IdentityDbContext<IdentityUser, IdentityRole, string>
    {
        public IdentityAppDbContext(DbContextOptions options) : base(options)
        {
        }
    }
}