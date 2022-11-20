using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3de0_BLL.Dtos
{
    public class CreateCommentDto
    {
        public string Content { get; set; }
        public int Rating { get; set; }

        public int CaffFileId { get; set; }
    }
}
