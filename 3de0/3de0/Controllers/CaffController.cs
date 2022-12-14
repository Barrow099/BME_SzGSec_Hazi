using _3de0_BLL;
using _3de0_BLL.Dtos;
using _3de0_BLL.Exceptions;
using _3de0_BLL.Paging;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using System.Net.Http.Headers;
using System.Security.Claims;

namespace _3de0.Controllers
{ 
    [ApiController]
    [Authorize]
    [Route("[controller]")]
    public class CaffController : ControllerBase
    {
        private readonly ICaffService _caffService;
        private readonly string pathDir = "CaffFiles/";

        public CaffController(ICaffService caffService)
        {
            _caffService = caffService;
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IEnumerable<CaffFilePreviewDto>> GetAllCaffFiles([FromQuery] Filter filter)
        {
            return await _caffService.GetCaffFileList(filter);
        }

        [Route("paged")]
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<PagedResult<CaffFilePreviewDto>> GetAllCaffFilesPaged([FromQuery] PaginationData pagination,[FromQuery] Filter filter)
        {
            return await _caffService.GetCaffFileListWithPaging(filter, pagination);
        }

        [Route("histories")]
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IEnumerable<HistoryDto>> GetAllHistories()
        {
            var userId = HttpContext.User.Claims.FirstOrDefault(u => u.Type == ClaimTypes.NameIdentifier)?.Value;
            return await _caffService.GetHistories(userId);
        }

        [Route("histories/paged")]
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<PagedResult<HistoryDto>> GetAllHistoriesPaged([FromQuery] PaginationData pagination)
        {
            var userId = HttpContext.User.Claims.FirstOrDefault(u => u.Type == ClaimTypes.NameIdentifier)?.Value;
            return await _caffService.GetHistoriesWithPaging(userId, pagination);
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
            var userId = HttpContext.User.Claims.FirstOrDefault(u => u.Type == ClaimTypes.NameIdentifier)?.Value;
            var file = await _caffService.DownloadCaffFile(id, userId);
            return File(file.data, "application/octet-stream", fileDownloadName: file.name);
        }

        [Route("{id}/preview")]
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetImagePreviewByCaffId(int id)
        {
            var file = await _caffService.GetPreviewImageByCaffId(id);
            return File(file, "image/png");
        }

        [Route("{id}")]
        [HttpPut]
        [Authorize(Roles = "admin")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> ModifyCaffFile(int id, [FromForm] UploadCaffFileDto modifyCaffFile)
        {
            var userId = HttpContext.User.Claims.FirstOrDefault(u => u.Type == ClaimTypes.NameIdentifier)?.Value;

            if (modifyCaffFile.File.Length > 0)
            {
                Directory.CreateDirectory(pathDir);
                string newFileName = Guid.NewGuid().ToString() + ".caff";
                string path = $"{pathDir}{newFileName}";

                using (var stream = new FileStream(path, FileMode.Create))
                {
                    modifyCaffFile.File.CopyTo(stream);
                }
                await _caffService.ModifyCaffFile(id, modifyCaffFile, userId!, path);

                return Ok();
            }
            else
            {
                throw new NotFoundException("File not found.");
            }
        }

        [Route("new")]
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<CaffFilePreviewDto> UploadCaffFile([FromForm] UploadCaffFileDto uploadCaffFile)
        {
            var userId = HttpContext.User.Claims.FirstOrDefault(u => u.Type == ClaimTypes.NameIdentifier)?.Value;

            if (uploadCaffFile.File.Length > 0)
            {
                Directory.CreateDirectory(pathDir);
                string newFileName = Guid.NewGuid().ToString() + ".caff";
                string path = $"{pathDir}{newFileName}";

                using (var stream = new FileStream(path, FileMode.Create))
                {
                    uploadCaffFile.File.CopyTo(stream);
                }
                return await _caffService.UploadCaffFile(uploadCaffFile, userId!, path);
            }
            else
            {
                throw new NotFoundException("File not found.");
            }

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