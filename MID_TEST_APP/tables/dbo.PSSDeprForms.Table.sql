USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSDeprForms]    Script Date: 12/21/2015 14:26:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSDeprForms](
	[Code] [char](15) NOT NULL,
	[Crtd_datetime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Description] [char](255) NOT NULL,
	[EndYear] [char](4) NOT NULL,
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
ALTER TABLE [dbo].[PSSDeprForms] ADD  DEFAULT ('') FOR [Code]
GO
ALTER TABLE [dbo].[PSSDeprForms] ADD  DEFAULT ('01/01/1900') FOR [Crtd_datetime]
GO
ALTER TABLE [dbo].[PSSDeprForms] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSDeprForms] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSDeprForms] ADD  DEFAULT ('') FOR [Description]
GO
ALTER TABLE [dbo].[PSSDeprForms] ADD  DEFAULT ('') FOR [EndYear]
GO
ALTER TABLE [dbo].[PSSDeprForms] ADD  DEFAULT ('') FOR [Form]
GO
ALTER TABLE [dbo].[PSSDeprForms] ADD  DEFAULT ('01/01/1900') FOR [Lupd_datetime]
GO
ALTER TABLE [dbo].[PSSDeprForms] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSDeprForms] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSDeprForms] ADD  DEFAULT ('') FOR [StartYear]
GO
