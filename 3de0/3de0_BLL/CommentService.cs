using _3de0_BLL.Dtos;
using _3de0_BLL_DAL;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Serilog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3de0_BLL
{
    public class CommentService : ICommentService
    {
        private readonly AppDbContext _caffDbContext;
        private readonly IdentityDbContext _identityDbContext;

        public CommentService(AppDbContext caffDbContext, IdentityDbContext identityDbContext)
        {
            _caffDbContext = caffDbContext;
            _identityDbContext = identityDbContext;
        }

        public async Task<CommentDto> AddComment(CreateCommentDto comment)
        {
            var caffFile = await _caffDbContext.Files
                .Where(caff => caff.Id == comment.CaffFileId)
                .SingleOrDefaultAsync();

            if (caffFile == null)
            {
                throw new FileNotFoundException("File not found.");
            }

            var user = await _identityDbContext.Users
                .SingleOrDefaultAsync(user => user.Id == comment.UserId);

            if (user == null)
            {
                throw new Exception("User doesn't exists.");
            }

            if (string.IsNullOrEmpty(comment.Content) || comment.Rating < 0 || comment.Rating > 5)
            {
                throw new Exception("Invalid parameters for creating comment.");
            }

            var newComment = new Comment()
            {
                Content = comment.Content,
                Rating = comment.Rating,
                UserId = user.Id,
                CaffFileId = caffFile.Id,
                CreationDate = DateTime.Now
            };

            var result = _caffDbContext.Comments.Add(newComment);
            await _caffDbContext.SaveChangesAsync();

            Log.Logger.Information($"User {user.UserName} [id: {user.Id}] create a comment on a CAFF file. [file path: {caffFile.FilePath}]");

            return new CommentDto()
            {
                Id = result.Entity.Id,
                CaffFileId = result.Entity.CaffFileId,
                Content = result.Entity.Content,
                CreationDate = result.Entity.CreationDate,
                Rating = result.Entity.Rating,
                UserId = result.Entity.UserId,
                UserName = user.UserName,
            };
        }

        public async Task ModifyCommentById(int id, CreateCommentDto modifyComment, string userId)
        {
            var comment = await _caffDbContext.Comments
                .Include(com => com.CaffFile)
                .SingleOrDefaultAsync(com => com.Id == id);

            if (comment == null)
            {
                throw new Exception("Comment doesn't exists.");
            }

            var modifierUser = await _identityDbContext.Users
                .SingleOrDefaultAsync(user => user.Id == userId);

            if (modifierUser == null)
            {
                throw new Exception("User doesn't exists.");
            }

            if (!string.IsNullOrEmpty(modifyComment.Content))
            {
                comment.Content = modifyComment.Content;
            }
            else if (modifyComment.Rating >= 0 && modifyComment.Rating <= 5)
            {
                comment.Rating = modifyComment.Rating;
            }

            await _caffDbContext.SaveChangesAsync();

            Log.Logger.Information($"User {modifierUser.UserName} [id: {modifierUser.Id}] edited a comment on a CAFF file. [file path: {comment.CaffFile.FilePath}]");
        }

        public async Task RemoveCommentById(int id, string userId)
        {
            var comment = await _caffDbContext.Comments
                 .Include(com => com.CaffFile)
                 .SingleOrDefaultAsync(com => com.Id == id);

            if (comment == null)
            {
                throw new Exception("Comment doesn't exists.");
            }

            var modifierUser = await _identityDbContext.Users
                .SingleOrDefaultAsync(user => user.Id == userId);

            if (modifierUser == null)
            {
                throw new Exception("User doesn't exists.");
            }

            _caffDbContext.Comments.Remove(comment);
            await _caffDbContext.SaveChangesAsync();

            Log.Logger.Information($"User {modifierUser.UserName} [id: {modifierUser.Id}] deleted a comment on a CAFF file. [file path: {comment.CaffFile.FilePath}]");
        }
    }
}
