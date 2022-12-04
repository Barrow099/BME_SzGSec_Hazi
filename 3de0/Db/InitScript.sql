USE [master]
GO
/****** Object:  Database [3de0db]    Script Date: 2022. 11. 23. 17:59:35 ******/
CREATE DATABASE [3de0db]
GO
ALTER DATABASE [3de0db] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [3de0db].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [3de0db] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [3de0db] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [3de0db] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [3de0db] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [3de0db] SET ARITHABORT OFF 
GO
ALTER DATABASE [3de0db] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [3de0db] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [3de0db] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [3de0db] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [3de0db] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [3de0db] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [3de0db] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [3de0db] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [3de0db] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [3de0db] SET  ENABLE_BROKER 
GO
ALTER DATABASE [3de0db] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [3de0db] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [3de0db] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [3de0db] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [3de0db] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [3de0db] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [3de0db] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [3de0db] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [3de0db] SET  MULTI_USER 
GO
ALTER DATABASE [3de0db] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [3de0db] SET DB_CHAINING OFF 
GO
ALTER DATABASE [3de0db] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [3de0db] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [3de0db] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [3de0db] SET QUERY_STORE = OFF
GO
USE [3de0db]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [3de0db]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 2022. 11. 23. 17:59:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 2022. 11. 23. 17:59:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Content] [nvarchar](max) NULL,
	[CreationDate] [datetime2](7) NOT NULL,
	[Rating] [int] NULL,
	[UserId] [nvarchar](max) NULL,
	[CaffFileId] [int] NOT NULL,
 CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Files]    Script Date: 2022. 11. 23. 17:59:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Files](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Creator] [nvarchar](max) NULL,
	[CreationDate] [datetime2](7) NOT NULL,
	[Price] [int] NOT NULL,
	[OwnerId] [nvarchar](max) NULL,
	[FilePath] [nvarchar](max) NULL,
	[Caption] [nvarchar](max) NULL,
 CONSTRAINT [PK_Files] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Histories]    Script Date: 2022. 11. 23. 17:59:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Histories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](max) NULL,
	[CaffFileId] [int] NOT NULL,
	[CaffFileName] [nvarchar](max) NULL,
	[DownloadedDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Histories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20221011160126_init', N'6.0.10')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20221024084128_AddedCaffFilePath', N'6.0.10')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20221024121931_AddedCaffFileIdToComment', N'6.0.10')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20221112171428_NewColumnsForCaff', N'6.0.10')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20221120203314_CommentRatingNullable', N'6.0.10')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20221120211506_HistoryTable', N'6.0.10')
GO
/****** Object:  Index [IX_Comments_CaffFileId]    Script Date: 2022. 11. 23. 17:59:35 ******/
CREATE NONCLUSTERED INDEX [IX_Comments_CaffFileId] ON [dbo].[Comments]
(
	[CaffFileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Comments] ADD  DEFAULT ((0)) FOR [CaffFileId]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_Files_CaffFileId] FOREIGN KEY([CaffFileId])
REFERENCES [dbo].[Files] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Files_CaffFileId]
GO
USE [master]
GO
ALTER DATABASE [3de0db] SET  READ_WRITE 
GO
USE [master]
GO
/****** Object:  Database [3de0db_Identity]    Script Date: 2022. 11. 23. 18:00:00 ******/
CREATE DATABASE [3de0db_Identity]
GO
ALTER DATABASE [3de0db_Identity] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [3de0db_Identity].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [3de0db_Identity] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [3de0db_Identity] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [3de0db_Identity] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [3de0db_Identity] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [3de0db_Identity] SET ARITHABORT OFF 
GO
ALTER DATABASE [3de0db_Identity] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [3de0db_Identity] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [3de0db_Identity] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [3de0db_Identity] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [3de0db_Identity] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [3de0db_Identity] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [3de0db_Identity] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [3de0db_Identity] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [3de0db_Identity] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [3de0db_Identity] SET  ENABLE_BROKER 
GO
ALTER DATABASE [3de0db_Identity] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [3de0db_Identity] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [3de0db_Identity] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [3de0db_Identity] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [3de0db_Identity] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [3de0db_Identity] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [3de0db_Identity] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [3de0db_Identity] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [3de0db_Identity] SET  MULTI_USER 
GO
ALTER DATABASE [3de0db_Identity] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [3de0db_Identity] SET DB_CHAINING OFF 
GO
ALTER DATABASE [3de0db_Identity] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [3de0db_Identity] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [3de0db_Identity] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [3de0db_Identity] SET QUERY_STORE = OFF
GO
USE [3de0db_Identity]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [3de0db_Identity]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 2022. 11. 23. 18:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 2022. 11. 23. 18:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 2022. 11. 23. 18:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](256) NULL,
	[NormalizedName] [nvarchar](256) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 2022. 11. 23. 18:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 2022. 11. 23. 18:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](450) NOT NULL,
	[ProviderKey] [nvarchar](450) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 2022. 11. 23. 18:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](450) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 2022. 11. 23. 18:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](450) NOT NULL,
	[UserName] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[Email] [nvarchar](256) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
 CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 2022. 11. 23. 18:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserTokens](
	[UserId] [nvarchar](450) NOT NULL,
	[LoginProvider] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](450) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20221022114309_init', N'6.0.10')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20221022124110_Added-roles', N'6.0.10')
GO
INSERT [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp]) VALUES (N'7de1079e-071b-43b4-be59-a3b8a4fcb153', N'admin', N'ADMIN', N'5af3f71a-fc55-429d-a951-b6c4541b22d5')
INSERT [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp]) VALUES (N'f4a0ff6d-40e4-4f3e-be03-f94518cac401', N'user', N'USER', N'd866cbdf-aa66-479e-8efb-7fe2c5ecee8c')
GO
SET IDENTITY_INSERT [dbo].[AspNetUserClaims] ON 

INSERT [dbo].[AspNetUserClaims] ([Id], [UserId], [ClaimType], [ClaimValue]) VALUES (1, N'12398deb-e98f-4ae5-b01a-6e47f72ce815', N'name', N'Alice Smith')
INSERT [dbo].[AspNetUserClaims] ([Id], [UserId], [ClaimType], [ClaimValue]) VALUES (2, N'12398deb-e98f-4ae5-b01a-6e47f72ce815', N'given_name', N'Alice')
INSERT [dbo].[AspNetUserClaims] ([Id], [UserId], [ClaimType], [ClaimValue]) VALUES (3, N'12398deb-e98f-4ae5-b01a-6e47f72ce815', N'family_name', N'Smith')
INSERT [dbo].[AspNetUserClaims] ([Id], [UserId], [ClaimType], [ClaimValue]) VALUES (4, N'12398deb-e98f-4ae5-b01a-6e47f72ce815', N'website', N'http://alice.com')
INSERT [dbo].[AspNetUserClaims] ([Id], [UserId], [ClaimType], [ClaimValue]) VALUES (5, N'12398deb-e98f-4ae5-b01a-6e47f72ce815', N'role', N'user')
INSERT [dbo].[AspNetUserClaims] ([Id], [UserId], [ClaimType], [ClaimValue]) VALUES (6, N'849d5c8b-1180-4047-99b6-897aafdeac28', N'name', N'Bob Smith')
INSERT [dbo].[AspNetUserClaims] ([Id], [UserId], [ClaimType], [ClaimValue]) VALUES (7, N'849d5c8b-1180-4047-99b6-897aafdeac28', N'given_name', N'Bob')
INSERT [dbo].[AspNetUserClaims] ([Id], [UserId], [ClaimType], [ClaimValue]) VALUES (8, N'849d5c8b-1180-4047-99b6-897aafdeac28', N'family_name', N'Smith')
INSERT [dbo].[AspNetUserClaims] ([Id], [UserId], [ClaimType], [ClaimValue]) VALUES (9, N'849d5c8b-1180-4047-99b6-897aafdeac28', N'website', N'http://bob.com')
INSERT [dbo].[AspNetUserClaims] ([Id], [UserId], [ClaimType], [ClaimValue]) VALUES (10, N'849d5c8b-1180-4047-99b6-897aafdeac28', N'location', N'somewhere')
INSERT [dbo].[AspNetUserClaims] ([Id], [UserId], [ClaimType], [ClaimValue]) VALUES (11, N'849d5c8b-1180-4047-99b6-897aafdeac28', N'role', N'admin')
SET IDENTITY_INSERT [dbo].[AspNetUserClaims] OFF
GO
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'849d5c8b-1180-4047-99b6-897aafdeac28', N'7de1079e-071b-43b4-be59-a3b8a4fcb153')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'12398deb-e98f-4ae5-b01a-6e47f72ce815', N'f4a0ff6d-40e4-4f3e-be03-f94518cac401')
GO
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount]) VALUES (N'12398deb-e98f-4ae5-b01a-6e47f72ce815', N'alice', N'ALICE', N'AliceSmith@email.com', N'ALICESMITH@EMAIL.COM', 1, N'AQAAAAEAACcQAAAAEFQUIyOPMduYmL/kSjTra3Ykkc1qgigIA8s7FWPqZ6IJi0mW/Eln4m99MK6UosxZuQ==', N'GLNWEVWC2KYM5LVOHWK7V5L3AKOKSEJI', N'964608f7-d341-4875-8014-b961ee0bf1bb', NULL, 0, 0, NULL, 1, 0)
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount]) VALUES (N'849d5c8b-1180-4047-99b6-897aafdeac28', N'bob', N'BOB', N'BobSmith@email.com', N'BOBSMITH@EMAIL.COM', 1, N'AQAAAAEAACcQAAAAEGwccPESY4iuOMhERXaF203PN/GEYV5pz9wb7Vx+GANF3RQ7GdH3/XyXlE3AVi6bsQ==', N'SROM5NMNU2GOIQVLW7Z7N2OEAIELDDRK', N'589f8dda-b40e-439f-ab66-353a6a1c1a20', NULL, 0, 0, NULL, 1, 0)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: 2022. 11. 23. 18:00:00 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [RoleNameIndex]    Script Date: 2022. 11. 23. 18:00:00 ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[NormalizedName] ASC
)
WHERE ([NormalizedName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: 2022. 11. 23. 18:00:00 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: 2022. 11. 23. 18:00:00 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: 2022. 11. 23. 18:00:00 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [EmailIndex]    Script Date: 2022. 11. 23. 18:00:00 ******/
CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UserNameIndex]    Script Date: 2022. 11. 23. 18:00:00 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedUserName] ASC
)
WHERE ([NormalizedUserName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AspNetRoleClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetRoleClaims] CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserTokens]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserTokens] CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
GO
USE [master]
GO
ALTER DATABASE [3de0db_Identity] SET  READ_WRITE 
GO
