USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSDeprFormDet]    Script Date: 12/21/2015 14:33:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSDeprFormDet](
	[Amount] [float] NOT NULL,
	[BookCode] [char](10) NOT NULL,
	[Code] [char](15) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_datetime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Description] [char](255) NOT NULL,
	[Form] [char](10) NOT NULL,
	[Lupd_datetime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[StartYear] [char](4) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSDeprFormDet] ADD  DEFAULT ((0.00)) FOR [Amount]
GO
ALTER TABLE [dbo].[PSSDeprFormDet] ADD  DEFAULT ('') FOR [BookCode]
GO
ALTER TABLE [dbo].[PSSDeprFormDet] ADD  DEFAULT ('') FOR [Code]
GO
ALTER TABLE [dbo].[PSSDeprFormDet] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSDeprFormDet] ADD  DEFAULT ('01/01/1900') FOR [Crtd_datetime]
GO
ALTER TABLE [dbo].[PSSDeprFormDet] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSDeprFormDet] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSDeprFormDet] ADD  DEFAULT ('') FOR [Description]
GO
ALTER TABLE [dbo].[PSSDeprFormDet] ADD  DEFAULT ('') FOR [Form]
GO
ALTER TABLE [dbo].[PSSDeprFormDet] ADD  DEFAULT ('01/01/1900') FOR [Lupd_datetime]
GO
ALTER TABLE [dbo].[PSSDeprFormDet] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSDeprFormDet] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSDeprFormDet] ADD  DEFAULT ('') FOR [StartYear]
GO
