USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[EDWrkPriceCmp]    Script Date: 12/21/2015 15:42:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDWrkPriceCmp](
	[ComputerID] [char](21) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[EDIPOID] [char](10) NOT NULL,
	[EDIPrice] [float] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[PODate] [smalldatetime] NOT NULL,
	[QtyPO] [float] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[SolDisc] [float] NOT NULL,
	[SolPrice] [float] NOT NULL,
	[UOMPO] [char](6) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EDWrkPriceCmp] ADD  CONSTRAINT [DF_EDWrkPriceCmp_ComputerID]  DEFAULT (' ') FOR [ComputerID]
GO
ALTER TABLE [dbo].[EDWrkPriceCmp] ADD  CONSTRAINT [DF_EDWrkPriceCmp_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[EDWrkPriceCmp] ADD  CONSTRAINT [DF_EDWrkPriceCmp_CustID]  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[EDWrkPriceCmp] ADD  CONSTRAINT [DF_EDWrkPriceCmp_EDIPOID]  DEFAULT (' ') FOR [EDIPOID]
GO
ALTER TABLE [dbo].[EDWrkPriceCmp] ADD  CONSTRAINT [DF_EDWrkPriceCmp_EDIPrice]  DEFAULT ((0)) FOR [EDIPrice]
GO
ALTER TABLE [dbo].[EDWrkPriceCmp] ADD  CONSTRAINT [DF_EDWrkPriceCmp_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[EDWrkPriceCmp] ADD  CONSTRAINT [DF_EDWrkPriceCmp_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[EDWrkPriceCmp] ADD  CONSTRAINT [DF_EDWrkPriceCmp_PODate]  DEFAULT ('01/01/1900') FOR [PODate]
GO
ALTER TABLE [dbo].[EDWrkPriceCmp] ADD  CONSTRAINT [DF_EDWrkPriceCmp_QtyPO]  DEFAULT ((0)) FOR [QtyPO]
GO
ALTER TABLE [dbo].[EDWrkPriceCmp] ADD  CONSTRAINT [DF_EDWrkPriceCmp_RI_ID]  DEFAULT ((0)) FOR [RI_ID]
GO
ALTER TABLE [dbo].[EDWrkPriceCmp] ADD  CONSTRAINT [DF_EDWrkPriceCmp_SolDisc]  DEFAULT ((0)) FOR [SolDisc]
GO
ALTER TABLE [dbo].[EDWrkPriceCmp] ADD  CONSTRAINT [DF_EDWrkPriceCmp_SolPrice]  DEFAULT ((0)) FOR [SolPrice]
GO
ALTER TABLE [dbo].[EDWrkPriceCmp] ADD  CONSTRAINT [DF_EDWrkPriceCmp_UOMPO]  DEFAULT (' ') FOR [UOMPO]
GO
