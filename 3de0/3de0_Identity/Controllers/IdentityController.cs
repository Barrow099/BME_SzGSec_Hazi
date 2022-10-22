using _3de0_Identity.Data;
using _3de0_Identity.Dtos;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

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
        public IActionResult Register([FromBody] UserRegistrationDto dto) 
        {
            var user = new IdentityUser()
            {
                UserName = dto.DisplayName,
                Email = dto.Email,
                EmailConfirmed = true
            };
            var result = userManager.CreateAsync(user, dto.Password).Result;
            if (!result.Succeeded)
                return BadRequest(result.Errors.First().Description);
            
            result = userManager.AddToRoleAsync(user, "user").Result;
            if (!result.Succeeded)
                return BadRequest(result.Errors.First().Description);

            return Ok();
        }
    }
}
