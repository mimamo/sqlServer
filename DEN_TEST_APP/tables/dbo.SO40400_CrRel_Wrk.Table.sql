USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[SO40400_CrRel_Wrk]    Script Date: 12/21/2015 14:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SO40400_CrRel_Wrk](
	[AutoAdvanceDone] [smallint] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
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
	[ShipperID] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_AutoAdvanceDone]  DEFAULT ((0)) FOR [AutoAdvanceDone]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_OrdNbr]  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SO40400_CrRel_Wrk] ADD  CONSTRAINT [DF_SO40400_CrRel_Wrk_ShipperID]  DEFAULT (' ') FOR [ShipperID]
GO
