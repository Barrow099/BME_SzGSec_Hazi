using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace _3de0.Controllers
{ 
    [ApiController]
    [Authorize]
    [Route("[controller]")]
    public class CaffController : ControllerBase
    {
        //CAFF felt�lt�s
        [HttpPost]
        public IActionResult Test() 
        {
            return Ok();
        }
    }
}


/*----
 * 
 * CAFF let�lt�s
 * CAFF m�dos�t�s
 * CAFF t�rl�s
 * CAFF kommentez�s
 * CAFF komment t�rl�s
 * CAFF komment m�dos�t�s
 * Bel�p�s
 * Regisztr�ci�
 * Adatm�dos�t�s*/