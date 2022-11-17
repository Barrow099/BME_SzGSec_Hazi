using _3de0_BLL;
using _3de0_BLL.Exceptions;
using _3de0_BLL_DAL;
using _3de0_Identity.Data;
using Hellang.Middleware.ProblemDetails;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

namespace _3de0
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);


            builder.Services.AddCors(o => o.AddPolicy("MyPolicy", builder => builder.AllowAnyOrigin()
                   .AllowAnyMethod()
                   .AllowAnyHeader()));

            // Add services to the container.
            builder.Services.AddDbContext<AppDbContext>(options => options
             .UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"), opt => opt.MigrationsAssembly(typeof(Program).Assembly.GetName().Name)));

            builder.Services.AddDbContext<IdentityAppDbContext>(options => options
             .UseSqlServer(builder.Configuration.GetConnectionString("IdentityDbConnection"), opt => opt.MigrationsAssembly(typeof(IdentityAppDbContext).Assembly.GetName().Name)));

            builder.Services.AddScoped<ICaffService, CaffService>();
            builder.Services.AddScoped<ICommentService, CommentService>();

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle           
            builder.Services.AddSwaggerGen(config =>
            {
                // use it if you want to hide Paths and Definitions from OpenApi documentation correctly
                config.UseAllOfToExtendReferenceSchemas();

                config.DocumentFilter<HideInDocsFilter>();


                config.AddSecurityDefinition("oauth2", new OpenApiSecurityScheme
                {
                    Description = "OAuth2.0 Auth Code with PKCE",
                    Name = "oauth2",
                    Type = SecuritySchemeType.OAuth2,
                    Flows = new OpenApiOAuthFlows
                    {
                        AuthorizationCode = new OpenApiOAuthFlow
                        {
                            AuthorizationUrl = new Uri(builder.Configuration["Identity:AuthorizationUrl"]),
                            TokenUrl = new Uri(builder.Configuration["Identity:TokenUrl"]),
                            Scopes = new Dictionary<string, string>
                            {
                                {"openid", "Open id"},
                                {"profile", "Profile" },
                                { builder.Configuration["Identity:ApiScope"], "CAFF API" }
                            },                            
                        }
                    }
                });
                config.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "oauth2"}
                        },
                        new[] { builder.Configuration["SwaggerConfig:ApiScope"] }
                    }
                });
            });


            builder.Services.AddAuthentication("Bearer")
            .AddJwtBearer("Bearer", options =>
            {
                options.Authority = builder.Configuration["Identity:Authority"];
                options.Audience = builder.Configuration["Identity:Audience"];

                options.TokenValidationParameters.ValidateAudience = true;
                options.TokenValidationParameters.ValidateIssuer = true;
                options.TokenValidationParameters.ValidateIssuerSigningKey = true;
            });

            builder.Services.AddAuthorization(options => options.AddPolicy("ApiScope", policy =>
            {
                policy.RequireAuthenticatedUser();
                policy.RequireClaim("scope", "caffApi");
            }));


            builder.Services.AddProblemDetails(opt =>
            {
                opt.IncludeExceptionDetails = (context, ex) =>
                {
                    var environment = context.RequestServices.GetRequiredService<IHostEnvironment>();

                    return environment.IsDevelopment();
                };
                // This will map NotImplementedException to the 501 Not Implemented status code.
                opt.MapToStatusCode<NotImplementedException>(StatusCodes.Status501NotImplemented);

                // This will map HttpRequestException to the 503 Service Unavailable status code.
                opt.MapToStatusCode<HttpRequestException>(StatusCodes.Status503ServiceUnavailable);

                opt.MapToStatusCode<NotFoundException>(StatusCodes.Status404NotFound);

                opt.MapToStatusCode<InvalidParameterException>(StatusCodes.Status400BadRequest);

                opt.MapToStatusCode<CaffException>(StatusCodes.Status406NotAcceptable);

                // Because exceptions are handled polymorphically, this will act as a "catch all" mapping, which is why it's added last.
                // If an exception other than NotImplementedException and HttpRequestException is thrown, this will handle it.
                opt.MapToStatusCode<Exception>(StatusCodes.Status500InternalServerError);
            });

            builder.Services.AddAutoMapper(typeof(AutoMapperConfig).Assembly);

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI(config => 
                {
                    config.OAuthClientId(builder.Configuration["Identity:ClientId"]);
                    config.OAuthClientSecret(builder.Configuration["ClientSecrets:Swagger"]);
                    config.OAuthUsePkce();
                });

                app.Use((context, next) =>
                {
                    context.Request.Scheme = "https";
                    return next(context);
                });
            }
            app.UseCors("MyPolicy");
            app.UseHttpsRedirection();

            app.UseAuthentication();
            app.UseAuthorization();

            app.UseProblemDetails();

            app.MapControllers();

            app.Run();
        }
    }
}