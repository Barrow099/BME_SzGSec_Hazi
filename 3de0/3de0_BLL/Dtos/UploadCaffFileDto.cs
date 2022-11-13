using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3de0_BLL.Dtos
{
    public class UploadCaffFileDto
    {
        public IFormFile File { get; set; }
        public int Price { get; set; }
    }
}
