using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3de0_BLL.Paging
{
    public static class PagingExtension
    {
        public static async Task<PagedResult<T>> ToPagedListAsync<T>(this IQueryable<T> list, PaginationData pagination)
        {
            PagedResult<T> result = new PagedResult<T>()
            {
                AllResultsCount = await list.CountAsync(),
                PageNumber = pagination.PageNumber,
                PageSize = pagination.PageSize,
                Results = await list.Skip(pagination.PageSize * (pagination.PageNumber - 1)).Take(pagination.PageSize).ToListAsync()
            };

            return result;
        }

        public static PagedResult<T> ToPagedList<T>(this IQueryable<T> list, PaginationData pagination)
        {
            PagedResult<T> result = new PagedResult<T>()
            {
                AllResultsCount = list.Count(),
                PageNumber = pagination.PageNumber,
                PageSize = pagination.PageSize,
                Results = list.Skip(pagination.PageSize * (pagination.PageNumber - 1)).Take(pagination.PageSize).ToList()
            };

            return result;
        }
    }
}
