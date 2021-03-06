USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PSSFAAutoLimits]    Script Date: 12/21/2015 16:12:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFAAutoLimits](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VehicleType] [char](15) NOT NULL,
	[Yr1Addl30] [float] NOT NULL,
	[Yr1Addl50] [float] NOT NULL,
	[Yr1Limit] [float] NOT NULL,
	[Yr2Limit] [float] NOT NULL,
	[Yr3Limit] [float] NOT NULL,
	[Yr4AboveLimit] [float] NOT NULL,
	[YrPlacedSvc] [char](4) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('01/01/1900') FOR [EndDate]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('01/01/1900') FOR [StartDate]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('') FOR [VehicleType]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ((0.00)) FOR [Yr1Addl30]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ((0.00)) FOR [Yr1Addl50]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ((0.00)) FOR [Yr1Limit]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ((0.00)) FOR [Yr2Limit]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ((0.00)) FOR [Yr3Limit]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ((0.00)) FOR [Yr4AboveLimit]
GO
ALTER TABLE [dbo].[PSSFAAutoLimits] ADD  DEFAULT ('') FOR [YrPlacedSvc]
GO
