USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[CustomFtr]    Script Date: 12/21/2015 16:00:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomFtr](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Dependencies] [smallint] NOT NULL,
	[Exclusions] [smallint] NOT NULL,
	[FeatureDesc] [char](30) NOT NULL,
	[FeatureNbr] [char](4) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MaxQty] [float] NOT NULL,
	[MinQty] [float] NOT NULL,
	[MultiOpt] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[Required] [smallint] NOT NULL,
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
	[StartDate] [smalldatetime] NOT NULL,
	[Status] [char](1) NOT NULL,
	[StopDate] [smalldatetime] NOT NULL,
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
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [Dependencies]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [Exclusions]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [FeatureDesc]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [FeatureNbr]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [MaxQty]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [MinQty]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [MultiOpt]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [Required]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ('01/01/1900') FOR [StartDate]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ('01/01/1900') FOR [StopDate]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[CustomFtr] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
