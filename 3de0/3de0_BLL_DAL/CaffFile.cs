using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace _3de0_BLL_DAL
{
    public class CaffFile
    {
        public int Id { get; set; }
        public string Caption { get; set; }
        public DateTime CreationDate { get; set; }
        public string Creator { get; set; }
        public int Price { get; set; }
        public string FilePath { get; set; }

        public string OwnerId { get; set; }

        public ICollection<Comment> Comments { get; set; }
    }
}