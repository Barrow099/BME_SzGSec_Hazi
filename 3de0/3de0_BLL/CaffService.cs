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

        public async Task<byte[]> DownloadCaffFile(int id)
        {
            var caffFile = await _caffDbContext.Files
                .Where(caff => caff.Id == id)
                .Include(caff => caff.Comments)
                .SingleOrDefaultAsync();

            if (caffFile == null)
            {
                throw new NotFoundException($"File is not found by id {id}.");
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
                File = ImagePreviewFromPath(caffFile.FilePath),
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
                    Caption = caff.Caption,
                    File = ImagePreviewFromPath(caff.FilePath)
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

            try
            {
                CAFFAnimation animation = CAFFAnimation.fromFile(path);

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

                var image = ImagePreviewFromPath(path);
                return new CaffFilePreviewDto()
                {
                    Id = dbResult.Entity.Id,
                    CreationDate = dbResult.Entity.CreationDate,
                    Creator = dbResult.Entity.Creator,
                    Price = dbResult.Entity.Price,
                    Caption = dbResult.Entity.Caption,
                    File = image
                };
            }
            catch (Exception)
            {
                File.Delete(path);
                throw new InvalidParameterException("Invalid CAFF file, unable to upload.");
            }
        }

        static private byte[] ImagePreviewFromPath(string path)
        {
            CAFFAnimation CaffAnimation = CAFFAnimation.fromFile(path);

            Bitmap bitmap = new Bitmap((int)CaffAnimation.GetPreviewWidth(), (int)CaffAnimation.GetPreviewHeight(), System.Drawing.Imaging.PixelFormat.Format24bppRgb);

            var bitmapData = bitmap.LockBits(new Rectangle(0, 0, (int)CaffAnimation.GetPreviewWidth(), (int)CaffAnimation.GetPreviewHeight()), ImageLockMode.ReadWrite, bitmap.PixelFormat);

            var preview = CaffAnimation.GetPreview();
            var scan = bitmapData.Scan0;
            Marshal.Copy(preview!, 0, scan, preview.Length);

            bitmap.UnlockBits(bitmapData);
            RGBtoBGR(bitmap);

            byte[] result = null;
            using (MemoryStream stream = new MemoryStream())
            {
                bitmap.Save(stream, ImageFormat.Png);
                result = stream.ToArray();
            }

            bitmap.Dispose();

            return result;
        }

        public static void RGBtoBGR(Bitmap bmp)
        {
            BitmapData data = bmp.LockBits(new Rectangle(0, 0, bmp.Width, bmp.Height), ImageLockMode.ReadWrite, bmp.PixelFormat);
            int length = Math.Abs(data.Stride) * bmp.Height;
            unsafe { byte* rgbValues = (byte*)data.Scan0.ToPointer();
               for (int i = 0; i < length; i += 3) { byte dummy = rgbValues[i]; rgbValues[i] = rgbValues[i + 2]; rgbValues[i + 2] = dummy; }
            }
            bmp.UnlockBits(data);
        }
    }
}
