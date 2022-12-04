using _3de0_Identity;
using Microsoft.AspNetCore.Mvc.ApiExplorer;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace _3de0
{
    public class HideInDocsFilter : IDocumentFilter
    {
        public void Apply(OpenApiDocument swaggerDoc, DocumentFilterContext context)
        {
            foreach(ApiDescription description in context.ApiDescriptions) 
            {
                description.TryGetMethodInfo(out var info);
                var devAttributes = info.GetCustomAttributes(true)
                    .OfType<HideInDocsAttribute>()
                    .Distinct();

                if (devAttributes.Any())
                {
                    string kepath = description.RelativePath;
                    var removeRoutes = swaggerDoc.Paths.Where(x => x.Key.ToLower().Contains(kepath.ToLower())).ToList();

                    removeRoutes.ForEach(x => { swaggerDoc.Paths.Remove(x.Key); });
                }
            }
        }
    }
}
