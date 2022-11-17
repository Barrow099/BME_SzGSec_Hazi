using _3de0_BLL.Dtos;
using _3de0_BLL.Exceptions;
using _3de0_BLL_DAL;
using _3de0_Identity.Data;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using PInvokeTest;
using Serilog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using SkiaSharp;

namespace _3de0_BLL
{
    public class CaffService : ICaffService
    {
        private readonly AppDbContext _caffDbContext;
        private readonly IdentityAppDbContext _identityDbContext;

        private readonly string pathDir = "CaffFiles/";

        public CaffService(AppDbContext caffDbContext, IdentityAppDbContext identityDbContext)
        {
            _caffDbContext = caffDbContext;
            _identityDbContext = identityDbContext;
        }

        public async Task<byte[]> GetPreviewImageByCaffId(int id)
        {
            var caffFile = await _caffDbContext.Files
                .Where(caff => caff.Id == id)
                .Include(caff => caff.Comments)
                .SingleOrDefaultAsync();

            if (caffFile == null)
            {
                throw new NotFoundException($"File is not found by id {id}.");
            }

            var result = ImagePreviewFromPath(caffFile.FilePath);

            return result;
        }

        public async Task<(byte[] data, string name)> DownloadCaffFile(int id)
        {
            var caffFile = await _caffDbContext.Files
                .Where(caff => caff.Id == id)
                .Include(caff => caff.Comments)
                .SingleOrDefaultAsync();

            if (caffFile == null)
            {
                throw new NotFoundException($"File is not found by id {id}.");
            }

            return (File.ReadAllBytes(caffFile.FilePath), caffFile.FilePath.Split("/")[1]);
        }

        public async Task<CaffFileDto> GetCaffFileDetails(int id)
        {
            var caffFile = await _caffDbContext.Files
                .Where(caff => caff.Id == id)
                .Include(caff => caff.Comments)
                .SingleOrDefaultAsync();

            if (caffFile == null)
            {
                throw new NotFoundException($"File is not found by id {id}.");
            }

            var owner = await _identityDbContext.Users
                .SingleOrDefaultAsync(user => user.Id == caffFile.OwnerId);

            if (owner == null)
            {
                throw new NotFoundException($"User is not found by id {caffFile.OwnerId}.");
            }

            return new CaffFileDto()
            {
                Id = caffFile.Id,
                CreationDate = caffFile.CreationDate,
                Creator = caffFile.Creator,
                Price = caffFile.Price,
                Caption = caffFile.Caption,
                Comments = caffFile.Comments
                        .Select(comment => new CommentDto()
                        {
                            Id = comment.Id,
                            Content = comment.Content,
                            CreationDate = comment.CreationDate,
                            Rating = comment.Rating,
                            UserId = comment.UserId,
                            UserName = owner.UserName,
                            CaffFileId = caffFile.Id,
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
                    Creator = caff.Creator,
                    Caption = caff.Caption
                })
                .ToListAsync();
        }

        public async Task ModifyCaffFile(int id, UploadCaffFileDto modifyCaffFile, string userId, string path)
        {
            var caffFile = await _caffDbContext.Files
                .Where(caff => caff.Id == id)
                .Include(caff => caff.Comments)
                .SingleOrDefaultAsync();

            if (caffFile == null)
            {
                File.Delete(path);
                throw new NotFoundException($"File is not found by id {id}.");
            }

            if (modifyCaffFile.Price >= 0)
            {
                caffFile.Price = modifyCaffFile.Price;
            } else
            {
                File.Delete(path);
                throw new InvalidParameterException("Invalid price for CAFF file. It can't be negative number.");
            }

            try
            {
                var user = await _identityDbContext.Users
                .SingleOrDefaultAsync(user => user.Id == userId);

                if (user == null)
                {
                    throw new NotFoundException($"Owner is not found by id {userId}.");
                }

                CAFFAnimation animation = CAFFAnimation.fromFile(path);
                var firstFrame = animation.Frames.FirstOrDefault();

                caffFile.Creator = animation.Creator;
                caffFile.CreationDate = DateTime.Now;
                caffFile.Caption = firstFrame == null ? "" : firstFrame.Image.Caption;

                // Előző fájl kitörlése, majd az új útvonalának módosítása
                File.Delete(caffFile.FilePath);
                caffFile.FilePath = path;

                await _caffDbContext.SaveChangesAsync();

                Log.Logger.Information($"User {user.UserName} [id: {user.Id}] modified a CAFF file. [file path: {caffFile.FilePath}]");
            }
            catch (Exception)
            {
                File.Delete(path);
                throw new InvalidParameterException("Invalid CAFF file, unable to upload.");
            }
        }

        public async Task RemoveCaffFileById(int id, string userId)
        {
            var caffFile = await _caffDbContext.Files
                .Where(caff => caff.Id == id)
                .Include(caff => caff.Comments)
                .SingleOrDefaultAsync();

            if (caffFile == null)
            {
                throw new NotFoundException($"File is not found by id {id}.");
            }

            string filePath = caffFile.FilePath;

            var user = await _identityDbContext.Users
                .SingleOrDefaultAsync(user => user.Id == userId);

            if (user == null)
            {
                throw new NotFoundException($"Owner is not found by id {userId}.");
            }

            File.Delete(caffFile.FilePath);

            _caffDbContext.Files.Remove(caffFile);
            await _caffDbContext.SaveChangesAsync();

            Log.Logger.Information($"User {user.UserName} [id: {user.Id}] deleted a CAFF file. [file path: {filePath}]");
        }

        public async Task<CaffFilePreviewDto> UploadCaffFile(UploadCaffFileDto uploadCaffFile, string userId, string path)
        {
            if (uploadCaffFile.Price < 0)
            {
                File.Delete(path);
                throw new InvalidParameterException("Invalid price for CAFF file. It can't be negative number.");
            }
            CAFFAnimation animation = null;
            try
            {
                animation = CAFFAnimation.fromFile(path);

                var user = await _identityDbContext.Users
                    .SingleOrDefaultAsync(user => user.Id == userId);

                if (user == null)
                {
                    throw new NotFoundException($"User is not found by id {userId}.");
                }

                var firstFrame = animation.Frames.FirstOrDefault();
                var caffFile = new CaffFile()
                {
                    CreationDate = DateTime.Now,
                    FilePath = path,
                    Price = uploadCaffFile.Price,
                    Creator = animation.Creator,
                    Caption = firstFrame == null ? "" : firstFrame.Image.Caption,
                    OwnerId = user.Id
                };

                var dbResult = _caffDbContext.Files.Add(caffFile);
                await _caffDbContext.SaveChangesAsync();

                Log.Logger.Information($"User {user.UserName} [id: {user.Id}] uploaded a new CAFF file. [file path: {dbResult.Entity.FilePath}]");

                //var image = ImagePreviewFromPath(path);
                return new CaffFilePreviewDto()
                {
                    Id = dbResult.Entity.Id,
                    CreationDate = dbResult.Entity.CreationDate,
                    Creator = dbResult.Entity.Creator,
                    Price = dbResult.Entity.Price,
                    Caption = dbResult.Entity.Caption
                };
            }
            catch (Exception e)
            {
                File.Delete(path);
                throw new InvalidParameterException($"Invalid CAFF file, unable to upload. {e.Message}", e);
            }
        }

        static private byte[] ImagePreviewFromPath(string path)
        {
      /*      CAFFAnimation CaffAnimation = CAFFAnimation.fromFile(path);
            int width = (int)CaffAnimation.GetPreviewWidth();
            int height = (int)CaffAnimation.GetPreviewHeight();
            SkiaSharp.SKBitmap bitmap = new SkiaSharp.SKBitmap(width, height, SKColorType.Bgra8888, SKAlphaType.Opaque); 
            
            SKColor[] pixels = new SKColor[width * height];
                for (int row = 0; row < height; row++)
                    for (int col = 0; col < width; col++)
            {
                pixels[width * row + col] = new SKColor(0,0,0,255);
            }
            bitmap.Pixels = pixels;

            var preview = CaffAnimation.GetPreview();
            var bgra_preview = BGR2BGRA(preview!);
            Marshal.Copy(bgra_preview, 0, bitmap.GetPixels(), bgra_preview.Length);

            byte[] result = null;
            using (MemoryStream stream = new MemoryStream())
            {
                bitmap.Encode(stream, SKEncodedImageFormat.Png, 10);
                result = stream.ToArray();
            }

            bitmap.Dispose();*/

            return null;
        }

        public static byte[] BGR2BGRA(byte[] data)
        {
            var retval = new byte[data.Length / 3 * 4];
            
            int index = 0;
            int out_index = 0;
            while(index < data.Length) {
                for(int offset = 0; offset < 3; offset++) {
                    retval[out_index + offset] = data[index + offset];
                }
                retval[out_index + 3] = 255;
                index += 3;
                out_index += 4;
            }
            return retval;
        }
    }
}
