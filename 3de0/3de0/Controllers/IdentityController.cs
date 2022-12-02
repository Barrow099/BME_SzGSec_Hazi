using _3de0_Identity.Data;
using _3de0_Identity.Dtos;
using Duende.IdentityServer.Services;
using IdentityModel;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Serilog;
using System.Runtime.CompilerServices;
using System.Security.Claims;

namespace _3de0_Identity.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class IdentityController : ControllerBase
    {
        private readonly UserManager<IdentityUser> userManager;
        private readonly RoleManager<IdentityRole> roleManager;
        private readonly IdentityAppDbContext context;

        public IdentityController(UserManager<IdentityUser> userManager, RoleManager<IdentityRole> roleManager, IdentityAppDbContext context)
        {
            this.userManager = userManager;
            this.roleManager = roleManager;
            this.context = context;
        }

        [Route("Register")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [HttpPost]
        
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

        [Route("Roles/Promote")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [HttpPut]
        
        [Authorize(Roles = "admin")]
        public async Task<IActionResult> PromoteUserToAdmin([FromQuery] string userId)
        {
            var user = await userManager.FindByIdAsync(userId);

            if (user == null)
            {
                Log.Logger.Information($"User promotion with missing id: {userId} failed!");
                return NotFound($"User with id {userId} not found!");
            }

            var role = await roleManager.FindByNameAsync("admin");
            if (role == null)
            {
                var errorObjectResult = new ObjectResult("Role with name: admin not found");
                errorObjectResult.StatusCode = StatusCodes.Status500InternalServerError;
                return errorObjectResult;
            }

            await userManager.RemoveFromRoleAsync(user, "user");
            await userManager.AddToRoleAsync(user, role.Name);
            Log.Logger.Information($"User with id {userId} was promoted to admin role!");
            return Ok();
        }

        [Route("Profile")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [HttpPut]
        [Authorize]
        
        public async Task<IActionResult> UpdateProfile([FromBody] ProfileUpdateDto updateDto)
        {
            string userId = HttpContext.User.Claims.First(x => x.Type == "sub").Value;
            var user = await userManager.FindByIdAsync(userId);

            if (user == null)
                return NotFound($"User with id: {userId} not found");

            var result = await UpdateProfileAsync(user, updateDto);

            if (!result.Succeeded)
            {
                var errors = result.Errors.Select(x => x.Description);
                return BadRequest($"Error during the profile update: {string.Join(", ", errors)}");
            }

            Log.Logger.Information($"{userId}'s profile was updated!");
            return Ok();
        }

        [Route("{userId}")]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [Authorize(Roles = "admin")]
        
        [HttpDelete]
        public async Task<IActionResult> DeleteAccount([FromRoute] string userId)
        {
            var user = await userManager.FindByIdAsync(userId);

            var result = await userManager.DeleteAsync(user);

            if (!result.Succeeded)
                return BadRequest($"Error during the user deletion {result.Errors.Select(x => x.Description)}");

            Log.Logger.Information($"{userId}'s account was deleted by {HttpContext.User.Claims.FirstOrDefault(x => x.Type == "sub").Value}!");
            return Ok();
        }

        [Route("")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [Authorize]
        
        [HttpDelete]
        public async Task<IActionResult> DeleteAccount() 
        {
            var user = await userManager.FindByIdAsync(HttpContext.User.Claims.FirstOrDefault(x => x.Type == "sub").Value);

            if (user == null)
                return BadRequest("User not found!");

            var result = await userManager.DeleteAsync(user);

            if (!result.Succeeded)
                return BadRequest($"Error during the user deletion {result.Errors.Select(x => x.Description)}");

            Log.Logger.Information($"{user.Id} deleted their account!");
            return Ok();
        }

        [Route("")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [Authorize]
        [HttpGet]
        public async Task<IActionResult> GetAccounts() 
        {
            // Szerepkört is küldjünk vissza
            var users = await context.Users
                .OrderBy(x => x.Id)
                .Select(x => new UserProfileDto()
                { 
                    DisplayName = x.UserName,
                    Email = x.Email,
                    Id = x.Id                   
                }).ToListAsync();

            var userRoles = context.Users.OrderBy(x => x.Id).Select(user => userManager.GetRolesAsync(user));
            var roles = await Task.WhenAll(userRoles);

            for (int i = 0; i < users.Count; i++)
                users.ElementAt(i).Role = roles.ElementAt(i).First();

            return Ok(users);
        }


        private async Task<IdentityResult> AddClaimsAsync(IdentityUser user, string role) =>
            await userManager.AddClaimsAsync(user, new Claim[]{
                new Claim(JwtClaimTypes.Name, user.UserName),
                new Claim(JwtClaimTypes.Role, role)});

        private async Task<IdentityResult> UpdateProfileAsync(IdentityUser user, ProfileUpdateDto updateDto) 
        {
            user.UserName = !string.IsNullOrEmpty(updateDto.UserName) ? updateDto.UserName : user.UserName;
            user.Email = !string.IsNullOrEmpty(updateDto.Email) ?  updateDto.Email : user.Email;

            if (!string.IsNullOrEmpty(updateDto.Password)) 
            {
                var result = await userManager.RemovePasswordAsync(user);
                if (!result.Succeeded)
                    return result;

                result = await userManager.AddPasswordAsync(user, updateDto.Password);

                if (!result.Succeeded)
                    return result;
            }

            return await userManager.UpdateAsync(user);
        }
    }
}
