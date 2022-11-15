using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3de0_BLL.Dtos
{
    public class CaffFileDto
    {
        public int Id { get; set; }
        public string Caption { get; set; }
        public DateTime CreationDate { get; set; }
        public string Creator { get; set; }
        public int Price { get; set; }

        public string OwnerId { get; set; }
        public string OwnerName { get; set; }

        public ICollection<CommentDto> Comments { get; set; }
    }
}
