using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3de0_BLL.Dtos
{
    public class CommentDto
    {
        public int Id { get; set; }
        public string Content { get; set; }
        public DateTime CreationDate { get; set; }
        public int Rating { get; set; }

        public string UserId { get; set; }
        public string UserName { get; set; }
        public int CaffFileId { get; set; }
    }
}
