using Microsoft.AspNetCore.Identity;

namespace _3de0_BLL_DAL
{
    public class User : IdentityUser
    {
        public List<CaffFile> Files { get; set; }
    }
}
