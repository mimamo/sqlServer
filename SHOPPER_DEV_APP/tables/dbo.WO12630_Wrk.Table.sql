USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[WO12630_Wrk]    Script Date: 12/21/2015 14:33:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WO12630_Wrk](
	[CpnyID] [char](10) NOT NULL,
	[ID] [char](16) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[PlanRef] [char](5) NOT NULL,
	[PlanStatus] [char](1) NOT NULL,
	[Quantity] [float] NOT NULL,
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
	[Source] [char](3) NOT NULL,
	[Task] [char](32) NOT NULL,
	[TxnDate] [smalldatetime] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[User9] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [ID]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [PlanRef]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [PlanStatus]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ((0)) FOR [Quantity]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ((0)) FOR [RI_ID]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [Source]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [Task]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ('01/01/1900') FOR [TxnDate]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [User10]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[WO12630_Wrk] ADD  DEFAULT (' ') FOR [User9]
GO
