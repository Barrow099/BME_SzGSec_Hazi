using Duende.IdentityServer;
using Duende.IdentityServer.Models;

namespace _3de0_Identity
{
    public static class Config
    {
        public static IEnumerable<IdentityResource> IdentityResources =>
            new IdentityResource[]
            {
                new IdentityResources.OpenId(),
                new IdentityResources.Profile()
            };

        public static IEnumerable<ApiScope> ApiScopes =>
            new ApiScope[]
            {
                new ApiScope("apiScope", "CAFF API"),
            };

        public static IEnumerable<ApiResource> ApiResources =>
           new ApiResource[]
           {
                new ApiResource("apiResource", "Api Resource")
                {
                    Scopes = { "apiScope" }
                },
           };

        public static IEnumerable<Client> Clients(IConfiguration configuration) =>
            new Client[]
            {
                // machine to machine client
                new Client
                {
                    ClientId = configuration["Identity:ClientIds:Swagger"],
                    ClientSecrets = { new Secret(configuration["ClientSecrets:Swagger"].Sha256()) },

                    AllowedGrantTypes = GrantTypes.Code,
                    // scopes that client has access to
                    RedirectUris = { configuration["Identity:RedirectUris:Swagger"] },
                    AllowedScopes = new List<string>
                    {
                        IdentityServerConstants.StandardScopes.OpenId,
                        IdentityServerConstants.StandardScopes.Profile,
                        "apiScope",
                    },
                    AllowedCorsOrigins =
                    {
                        configuration["Identity:Cors:Swagger"],
                    },
                },

                // interactive ASP.NET Core Web App
                new Client
                {
                    ClientId = configuration["Identity:ClientIds:SPA"],
                    ClientSecrets = { new Secret(configuration["ClientSecrets:SPA"].Sha256()) },

                    AllowedGrantTypes = GrantTypes.Code,
                    
                    // where to redirect to after login
                    RedirectUris = { configuration["Identity:RedirectUris:SPA"] },

                    // where to redirect to after logout
                    PostLogoutRedirectUris = { configuration["Identity:PostLogoutRedirectUris"]  },

                    AllowOfflineAccess = true,

                    AllowedScopes = new List<string>
                    {
                        IdentityServerConstants.StandardScopes.OpenId,
                        IdentityServerConstants.StandardScopes.Profile,
                        "apiScope",
                    },
                    AllowedCorsOrigins =
                    {
                        configuration["Identity:Cors:SPA"],
                    },
                }
            };
    }
}
