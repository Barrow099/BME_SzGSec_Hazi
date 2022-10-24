using _3de0_BLL.Dtos;
using _3de0_BLL_DAL;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Serilog;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3de0_BLL
{
    public class CaffService : ICaffService
    {
        private readonly AppDbContext _caffDbContext;
        private readonly IdentityDbContext _identityDbContext;

        private readonly string pathDir = "CaffFiles/";

        public CaffService(AppDbContext caffDbContext, IdentityDbContext identityDbContext)
        {
            _caffDbContext = caffDbContext;
            _identityDbContext = identityDbContext;
        }

        public async Task<byte[]> DownloadCaffFile(int id)
        {
            var caffFile = await _caffDbContext.Files
                .Where(caff => caff.Id == id)
                .Include(caff => caff.Comments)
                .SingleOrDefaultAsync();

            if (caffFile == null)
            {
                throw new FileNotFoundException("File not found.");
            }

            return File.ReadAllBytes(caffFile.FilePath);
        }

        public async Task<CaffFileDto> GetCaffFileDetails(int id)
        {
            var caffFile = await _caffDbContext.Files
                .Where(caff => caff.Id == id)
                .Include(caff => caff.Comments)
                .SingleOrDefaultAsync();

            if (caffFile == null)
            {
                throw new FileNotFoundException("File not found.");
            }

            var owner = await _identityDbContext.Users
                .SingleOrDefaultAsync(user => user.Id == caffFile.OwnerId);

            if (owner == null)
            {
                throw new Exception("Owner doesn't exists.");
            }

            return new CaffFileDto()
            {
                Id = caffFile.Id,
                CreationDate = caffFile.CreationDate,
                Price = caffFile.Price,
                Title = caffFile.Title,
                File = File.ReadAllBytes(caffFile.FilePath),
                Comments = caffFile.Comments
                        .Select(comment => new CommentDto()
                        {
                            Id = comment.Id,
                            Content = comment.Content,
                            CreationDate = comment.CreationDate,
                            Rating = comment.Rating,
                            UserId = comment.UserId,
                        })
                        .ToList(),
                OwnerId = owner.Id,
                OwnerName = owner.UserName
            };
        }

        public async Task<IEnumerable<CaffFilePreviewDto>> GetCaffFileList()
        {
            return await _caffDbContext.Files
                .Select(caff => new CaffFilePreviewDto()
                {
                    Id = caff.Id,
                    CreationDate = caff.CreationDate,
                    Price = caff.Price,
                    Title = caff.Title,
                    File = File.ReadAllBytes(caff.FilePath)
                })
                .ToListAsync();
        }

        public async Task ModifyCaffFile(int id, UploadCaffFileDto modifyCaffFile, string userId)
        {
            var caffFile = await _caffDbContext.Files
                .Where(caff => caff.Id == id)
                .Include(caff => caff.Comments)
                .SingleOrDefaultAsync();

            if (caffFile == null)
            {
                throw new FileNotFoundException("File not found.");
            }

            if (modifyCaffFile.Price >= 0)
            {
                caffFile.Price = modifyCaffFile.Price;
            }
            else if (!string.IsNullOrEmpty(modifyCaffFile.Title))
            {
                caffFile.Title = modifyCaffFile.Title;
            }
            else if (modifyCaffFile.File.Length != 0)
            {
                await File.WriteAllBytesAsync(caffFile.FilePath, modifyCaffFile.File);
            }

            var user = await _identityDbContext.Users
                .SingleOrDefaultAsync(user => user.Id == userId);

            if (user == null)
            {
                throw new Exception("Owner doesn't exists.");
            }

            await _caffDbContext.SaveChangesAsync();

            Log.Logger.Information($"User {user.UserName} [id: {user.Id}] modified a CAFF file. [file path: {caffFile.FilePath}]");
        }

        public async Task RemoveCaffFileById(int id, string userId)
        {
            var caffFile = await _caffDbContext.Files
                .Where(caff => caff.Id == id)
                .Include(caff => caff.Comments)
                .SingleOrDefaultAsync();

            if (caffFile == null)
            {
                throw new FileNotFoundException("File not found.");
            }

            string filePath = caffFile.FilePath;

            var user = await _identityDbContext.Users
                .SingleOrDefaultAsync(user => user.Id == userId);

            if (user == null)
            {
                throw new Exception("Owner doesn't exists.");
            }

            File.Delete(caffFile.FilePath);

            _caffDbContext.Remove(caffFile);
            await _caffDbContext.SaveChangesAsync();

            Log.Logger.Information($"User {user.UserName} [id: {user.Id}] deleted a CAFF file. [file path: {filePath}]");
        }

        public async Task<CaffFilePreviewDto> UploadCaffFile(UploadCaffFileDto uploadCaffFile, string userId)
        {
            if (!checkCaffModel(uploadCaffFile))
            {
                throw new Exception("Invalid upload model.");
            }

            string newFileName = Guid.NewGuid().ToString() + "_" + uploadCaffFile.Title + ".caff";
            string path = $"{pathDir}{newFileName}";

            await File.WriteAllBytesAsync(path, uploadCaffFile.File);

            var user = await _identityDbContext.Users
                .SingleOrDefaultAsync(user => user.Id == userId);

            if (user == null)
            {
                throw new Exception("Owner doesn't exists.");
            }

            // TODO parser lefuttatása
            // TODO: Ezt lehet a fájlból kéne kiszedni
            var caffFile = new CaffFile()
            {
                CreationDate = DateTime.Now,
                FilePath = path,
                Price = uploadCaffFile.Price,
                Title = uploadCaffFile.Title,
                OwnerId = user.Id
            };

            var dbResult = _caffDbContext.Add(caffFile);
            await _caffDbContext.SaveChangesAsync();

            Log.Logger.Information($"User {user.UserName} [id: {user.Id}] uploaded a new CAFF file. [file path: {dbResult.Entity.FilePath}]");

            return new CaffFilePreviewDto()
            {
                Id = dbResult.Entity.Id,
                CreationDate = dbResult.Entity.CreationDate,
                Price = dbResult.Entity.Price,
                Title = dbResult.Entity.Title,
                File = File.ReadAllBytes(dbResult.Entity.FilePath)
            };
        }

        private bool checkCaffModel(UploadCaffFileDto caffModel)
        {
            if (caffModel.File.Length == 0) return false;
            if (string.IsNullOrEmpty(caffModel.Title)) return false;
            if (caffModel.Price < 0) return false;

            return true;
        }
    }
}
