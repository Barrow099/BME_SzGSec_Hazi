using _3de0_BLL.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3de0_BLL
{
    public interface ICommentService
    {
        Task ModifyCommentById(int id, ModifyCommentDto modifyComment, string userId);
        Task RemoveCommentById(int id, string userId);
        Task<CommentDto> AddComment(CreateCommentDto comment);
    }
}
