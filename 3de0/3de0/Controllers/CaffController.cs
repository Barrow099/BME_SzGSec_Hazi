using _3de0_BLL;
using _3de0_BLL.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace _3de0.Controllers
{ 
    [ApiController]
    [Authorize]
    [Route("[controller]")]
    public class CaffController : ControllerBase
    {
        private readonly ICaffService _caffService;
        public CaffController(ICaffService caffService)
        {
            _caffService = caffService;
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IEnumerable<CaffFilePreviewDto>> GetAllCaffFiles()
        {
            return await _caffService.GetCaffFileList();
        }

        [Route("{id}")]
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<CaffFileDto> GetCaffFileDetailsById(int id)
        {
            return await _caffService.GetCaffFileDetails(id);
        }

        [Route("{id}/download")]
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> DownloadCaffFile(int id)
        {
            var file = await _caffService.DownloadCaffFile(id);
            return File(file, "application/octet-stream");
        }

        [Route("{id}")]
        [HttpPut]
        [Authorize(Roles = "admin")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> ModifyCaffFile(int id, [FromBody] UploadCaffFileDto modifyCaffFile)
        {
            var userId = HttpContext.User.Claims.FirstOrDefault(u => u.Type == ClaimTypes.NameIdentifier)?.Value;
            await _caffService.ModifyCaffFile(id, modifyCaffFile, userId!);

            return Ok();
        }

        [Route("new")]
        [HttpPost]
        [Authorize(Roles = "admin")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<CaffFilePreviewDto> UploadCaffFile([FromBody] UploadCaffFileDto uploadCaffFile)
        {
            var userId = HttpContext.User.Claims.FirstOrDefault(u => u.Type == ClaimTypes.NameIdentifier)?.Value;
            return await _caffService.UploadCaffFile(uploadCaffFile, userId!);
        }

        [Route("delete/{id}")]
        [HttpDelete]
        [Authorize(Roles = "admin")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> DeleteCaffFile(int id)
        {
            var userId = HttpContext.User.Claims.FirstOrDefault(u => u.Type == ClaimTypes.NameIdentifier)?.Value;
            await _caffService.RemoveCaffFileById(id, userId!);

            return Ok();
        }
    }
}


/*----
 * CAFF kommentezés
 * CAFF komment törlés
 * CAFF komment módosítás*/