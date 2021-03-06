USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[PSSFAAssetLocHist]    Script Date: 12/21/2015 15:42:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFAAssetLocHist](
	[AssetId] [char](10) NOT NULL,
	[AssetSubId] [char](10) NOT NULL,
	[BuildNbr] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Custodian] [char](20) NOT NULL,
	[DateRcvd] [smalldatetime] NOT NULL,
	[DateRmvd] [smalldatetime] NOT NULL,
	[Dept] [char](24) NOT NULL,
	[LineId] [smallint] NOT NULL,
	[LocID] [char](24) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[Notes] [char](60) NOT NULL,
	[ProjectId] [char](30) NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[TaskId] [char](32) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VehicleDriver] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [AssetId]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [AssetSubId]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [BuildNbr]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [Custodian]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('01/01/1900') FOR [DateRcvd]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('01/01/1900') FOR [DateRmvd]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [Dept]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [LocID]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [Notes]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [ProjectId]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [RefNbr]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [TaskId]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSFAAssetLocHist] ADD  DEFAULT ('') FOR [VehicleDriver]
GO
