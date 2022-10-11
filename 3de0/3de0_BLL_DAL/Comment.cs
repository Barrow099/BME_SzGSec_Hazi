using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace _3de0_BLL_DAL
{
    public class Comment
    {
        public int Id { get; set; }
        public string Content { get; set; }
        public DateTime CreationDate { get; set; }
        public int Rating { get; set; }

        public string UserId { get; set; }
        public User User { get; set; }
    }
}