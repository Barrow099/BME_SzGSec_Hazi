using Duende.IdentityServer.Extensions;
using Duende.IdentityServer.Models;
using Duende.IdentityServer.Services;
using IdentityModel;
using Microsoft.AspNetCore.Identity;
using System.Security.Claims;

namespace _3de0_Identity
{
    public class ProfileService : IProfileService
    {
        private readonly UserManager<IdentityUser> userManager;
        private readonly RoleManager<IdentityRole> roleManager;
        private readonly IUserClaimsPrincipalFactory<IdentityUser> userClaimsPrincipalFactory;

        public ProfileService(UserManager<IdentityUser> userManager, IUserClaimsPrincipalFactory<IdentityUser> userClaimsPrincipalFactory, RoleManager<IdentityRole> roleManager)
        {
            this.userManager = userManager;
            this.userClaimsPrincipalFactory = userClaimsPrincipalFactory;
            this.roleManager = roleManager;
        }

        public async Task GetProfileDataAsync(ProfileDataRequestContext context)
        {
            string sub = context.Subject.GetSubjectId();
            var user = await userManager.FindByIdAsync(sub);
            var userClaims = await userClaimsPrincipalFactory.CreateAsync(user);

            var claims = userClaims.Claims.ToList();
            claims = claims.Where(claim => context.RequestedClaimTypes.Contains(claim.Type)).ToList();

            if (userManager.SupportsUserRole)
            {
                var roles = await userManager.GetRolesAsync(user);
                foreach (var roleName in roles)
                {
                    claims.Add(new Claim(JwtClaimTypes.Role, roleName));
                    if (roleManager.SupportsRoleClaims) 
                    {
                        var role = await roleManager.FindByNameAsync(roleName);
                        if (role != null) 
                        {
                            claims.AddRange(await roleManager.GetClaimsAsync(role));
                        }
                    }
                }
            }

            context.IssuedClaims = claims;
        }

        public Task IsActiveAsync(IsActiveContext context)
        {
            context.IsActive = true;
            return Task.CompletedTask;
        }
    }
}
