using _3de0_BLL.Dtos;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3de0_BLL
{
    public interface ICaffService
    {
        Task<IEnumerable<CaffFilePreviewDto>> GetCaffFileList();
        Task<CaffFileDto> GetCaffFileDetails(int id);
        Task ModifyCaffFile(int id, UploadCaffFileDto modifyCaffFile, string userId, string path);
        Task RemoveCaffFileById(int id, string userId);

        Task<CaffFilePreviewDto> UploadCaffFile(UploadCaffFileDto uploadCaffFile, string userId, string path);
        Task<byte[]> DownloadCaffFile(int id);
        Task<byte[]> GetPreviewImageByCaffId(int id);
    }
}
