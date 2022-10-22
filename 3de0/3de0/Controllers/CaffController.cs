using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace _3de0.Controllers
{ 
    [ApiController]
    [Authorize]
    [Route("[controller]")]
    public class CaffController : ControllerBase
    {
        //CAFF feltöltés
        [HttpPost]
        public IActionResult Test() 
        {
            return Ok();
        }
    }
}


/*----
 * 
 * CAFF letöltés
 * CAFF módosítás
 * CAFF törlés
 * CAFF kommentezés
 * CAFF komment törlés
 * CAFF komment módosítás
 * Belépés
 * Regisztráció
 * Adatmódosítás*/