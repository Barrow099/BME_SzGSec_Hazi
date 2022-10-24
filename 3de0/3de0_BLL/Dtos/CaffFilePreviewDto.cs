using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3de0_BLL.Dtos
{
    public class CaffFilePreviewDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public DateTime CreationDate { get; set; }
        public int Price { get; set; }
        public byte[] File { get; set; }
    }
}
