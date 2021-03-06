USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[IRDemandTran]    Script Date: 12/21/2015 14:10:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IRDemandTran](
	[Crtd_Datetime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DemandQty] [float] NOT NULL,
	[AdjustmentQty] [float] NOT NULL,
	[Descr] [char](80) NOT NULL,
	[IncludeInDemand] [smallint] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[Lupd_Datetime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[RecordID] [int] NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [float] NOT NULL,
	[S4Future03] [smalldatetime] NOT NULL,
	[S4Future04] [int] NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [float] NOT NULL,
	[User3] [smalldatetime] NOT NULL,
	[User4] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_Crtd_Datetime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_Datetime]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_DemandQty]  DEFAULT ((0)) FOR [DemandQty]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_AdjustmentQty]  DEFAULT ((0)) FOR [AdjustmentQty]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_IncludeInDemand]  DEFAULT ((0)) FOR [IncludeInDemand]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_Lupd_Datetime]  DEFAULT ('01/01/1900') FOR [Lupd_Datetime]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_PerPost]  DEFAULT (' ') FOR [PerPost]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_RecordID]  DEFAULT ((0)) FOR [RecordID]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_S4Future02]  DEFAULT ((0)) FOR [S4Future02]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_S4Future03]  DEFAULT ('01/01/1900') FOR [S4Future03]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_User2]  DEFAULT ((0)) FOR [User2]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_User3]  DEFAULT ('01/01/1900') FOR [User3]
GO
ALTER TABLE [dbo].[IRDemandTran] ADD  CONSTRAINT [DF_IRDemandTran_User4]  DEFAULT ((0)) FOR [User4]
GO
