USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSDeprSect]    Script Date: 12/21/2015 14:10:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSDeprSect](
	[Crtd_datetime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[Lupd_datetime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[Sect] [char](6) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSDeprSect] ADD  DEFAULT ('01/01/1900') FOR [Crtd_datetime]
GO
ALTER TABLE [dbo].[PSSDeprSect] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSDeprSect] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSDeprSect] ADD  DEFAULT ('') FOR [Descr]
GO
ALTER TABLE [dbo].[PSSDeprSect] ADD  DEFAULT ('01/01/1900') FOR [Lupd_datetime]
GO
ALTER TABLE [dbo].[PSSDeprSect] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSDeprSect] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSDeprSect] ADD  DEFAULT ('') FOR [Sect]
GO
