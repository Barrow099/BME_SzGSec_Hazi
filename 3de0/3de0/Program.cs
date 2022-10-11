using _3de0_BLL;
using _3de0_BLL_DAL;
using Hellang.Middleware.ProblemDetails;
using Microsoft.EntityFrameworkCore;

namespace _3de0
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddDbContext<AppDbContext>(options => options
             .UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"), opt => opt.MigrationsAssembly(typeof(Program).Assembly.GetName().Name)));

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

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
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}