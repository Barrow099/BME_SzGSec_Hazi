using _3de0_Identity.Data;
using _3de0_Identity.Dtos;
using IdentityModel;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Serilog;
using System.Security.Claims;

namespace _3de0_Identity.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class IdentityController : ControllerBase
    {
        private readonly UserManager<IdentityUser> userManager;

        public IdentityController(UserManager<IdentityUser> userManager)
        {
            this.userManager = userManager;
        }

        [Route("Register")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [HttpPost]
        [HideInDocs]
        public async Task<IActionResult> RegisterUser([FromBody] UserRegistrationDto dto)
        {
            var user = new IdentityUser()
            {
                UserName = dto.DisplayName,
                Email = dto.Email,
                EmailConfirmed = true
            };
            var result = await userManager.CreateAsync(user, dto.Password);
            if (!result.Succeeded)
                return BadRequest(result.Errors.First().Description);

            result = await userManager.AddToRoleAsync(user, "user");
            if (!result.Succeeded)
                return BadRequest(result.Errors.First().Description);

            result = await AddClaimsAsync(user, "user");
            if (!result.Succeeded)
                return BadRequest(result.Errors.First().Description);

            Log.Logger.Information($"User with email: {user.Email} and role: user created");
            return Ok();
        }

        [Route("Register/admin")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [HttpPost]
        [Authorize(Roles = "admin")]      
        public async Task<IActionResult> RegisterAdmin([FromBody] UserRegistrationDto dto)
        {
            var user = new IdentityUser()
            {
                UserName = dto.DisplayName,
                Email = dto.Email,
                EmailConfirmed = true
            };
            var result = await userManager.CreateAsync(user, dto.Password);
            if (!result.Succeeded)
                return BadRequest(result.Errors.First().Description);

            result = await userManager.AddToRoleAsync(user, "admin");
            if (!result.Succeeded)
                return BadRequest(result.Errors.First().Description);

            result = await AddClaimsAsync(user, "admin");
            if (!result.Succeeded)
                return BadRequest(result.Errors.First().Description);

            Log.Logger.Information($"User with email: {user.Email} and role: user created");
            return Ok();
        }

        private async Task<IdentityResult> AddClaimsAsync(IdentityUser user, string role) =>
            await userManager.AddClaimsAsync(user, new Claim[]{
                new Claim(JwtClaimTypes.Name, user.UserName),
                new Claim(JwtClaimTypes.Role, role)});
    }
}
