USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[IN10863_WRK]    Script Date: 12/21/2015 14:26:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IN10863_WRK](
	[ABCCode] [char](2) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[TotalSold] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT (' ') FOR [ABCCode]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT ((0)) FOR [RI_ID]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT ((0)) FOR [TotalSold]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[IN10863_WRK] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
