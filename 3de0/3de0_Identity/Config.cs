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
                new Client
                {
                    ClientId= "test",
                    ClientSecrets = { new Secret("test".Sha256()) },
                    AllowedGrantTypes = GrantTypes.ResourceOwnerPassword,
                    AllowedScopes = new List<string>
                    {
                        IdentityServerConstants.StandardScopes.OpenId,
                        IdentityServerConstants.StandardScopes.Profile,
                        "apiScope",
                    },
                },

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
                    ClientId = configuration["Identity:ClientIds:Flutter"],
                    RequireClientSecret = false,
                    AllowOfflineAccess = true,

                    AllowedGrantTypes = GrantTypes.Code,
                    
                    // where to redirect to after login
                    RedirectUris = { configuration["Identity:RedirectUris:Flutter"] },

                    // where to redirect to after logout
                    PostLogoutRedirectUris = { configuration["Identity:PostLogoutRedirectUris"]  },

                    AllowedScopes = new List<string>
                    {
                        IdentityServerConstants.StandardScopes.OpenId,
                        IdentityServerConstants.StandardScopes.Profile,
                        IdentityServerConstants.StandardScopes.OfflineAccess,
                        "apiScope",
                    },
                    /*AllowedCorsOrigins =
                    {
                        configuration["Identity:Cors:SPA"],
                    },*/
                }
            };
    }
}
