using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3de0_BLL.Paging
{
    public class PagedResult<T>
    {
        public IEnumerable<T> Results { get; set; }
        public int AllResultsCount { get; set; }
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 10;
    }
}
