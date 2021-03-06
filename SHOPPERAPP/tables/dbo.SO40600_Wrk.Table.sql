USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[SO40600_Wrk]    Script Date: 12/21/2015 16:12:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SO40600_Wrk](
	[Cntr] [smallint] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LotSerNbr00] [char](25) NOT NULL,
	[LotSerNbr01] [char](25) NOT NULL,
	[LotSerNbr02] [char](25) NOT NULL,
	[LotSerNbr03] [char](25) NOT NULL,
	[LotSerNbr04] [char](25) NOT NULL,
	[Qty00] [float] NOT NULL,
	[Qty01] [float] NOT NULL,
	[Qty02] [float] NOT NULL,
	[Qty03] [float] NOT NULL,
	[Qty04] [float] NOT NULL,
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
	[ShipperID] [char](15) NOT NULL,
	[WhseLoc] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ((0)) FOR [Cntr]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT (' ') FOR [LotSerNbr00]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT (' ') FOR [LotSerNbr01]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT (' ') FOR [LotSerNbr02]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT (' ') FOR [LotSerNbr03]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT (' ') FOR [LotSerNbr04]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ((0)) FOR [Qty00]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ((0)) FOR [Qty01]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ((0)) FOR [Qty02]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ((0)) FOR [Qty03]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ((0)) FOR [Qty04]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ((0)) FOR [RI_ID]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[SO40600_Wrk] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
