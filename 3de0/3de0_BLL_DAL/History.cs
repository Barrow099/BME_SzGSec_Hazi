using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3de0_BLL_DAL
{
    public class History
    {
        public int Id { get; set; }
        public string UserId { get; set; }
        public int CaffFileId { get; set; }
        public string CaffFileName { get; set; }
        public DateTime DownloadedDate { get; set; }
    }
}
