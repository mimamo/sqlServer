USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[EDPORcvdWrk]    Script Date: 12/21/2015 14:05:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDPORcvdWrk](
	[AccessNbr] [smallint] NOT NULL,
	[CancelDate] [smalldatetime] NOT NULL,
	[ConvertedDate] [smalldatetime] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[ED850OrdNbr] [char](15) NOT NULL,
	[ED850Price] [float] NOT NULL,
	[ED850PriceExt] [float] NOT NULL,
	[ED850Qty] [float] NOT NULL,
	[ED850ShipDate] [smalldatetime] NOT NULL,
	[ED850SKU] [char](48) NOT NULL,
	[ED850TotDisc] [float] NOT NULL,
	[ED850UOM] [char](6) NOT NULL,
	[ED850UPC] [char](48) NOT NULL,
	[EDIPOID] [char](10) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LineCounter] [int] NOT NULL,
	[LineID] [int] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[PODate] [smalldatetime] NOT NULL,
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
	[SODiscAmt] [float] NOT NULL,
	[SOQty] [float] NOT NULL,
	[SOSlsExt] [float] NOT NULL,
	[SOSlsNet] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [smalldatetime] NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [char](30) NOT NULL,
	[User4] [char](30) NOT NULL,
	[User5] [float] NOT NULL,
	[User6] [float] NOT NULL,
	[User7] [char](10) NOT NULL,
	[User8] [char](10) NOT NULL,
	[User9] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_AccessNbr]  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_CancelDate]  DEFAULT ('01/01/1900') FOR [CancelDate]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_ConvertedDate]  DEFAULT ('01/01/1900') FOR [ConvertedDate]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_CreateDate]  DEFAULT ('01/01/1900') FOR [CreateDate]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_ED850OrdNbr]  DEFAULT (' ') FOR [ED850OrdNbr]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_ED850Price]  DEFAULT ((0)) FOR [ED850Price]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_ED850PriceExt]  DEFAULT ((0)) FOR [ED850PriceExt]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_ED850Qty]  DEFAULT ((0)) FOR [ED850Qty]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_ED850ShipDate]  DEFAULT ('01/01/1900') FOR [ED850ShipDate]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_ED850SKU]  DEFAULT (' ') FOR [ED850SKU]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_ED850TotDisc]  DEFAULT ((0)) FOR [ED850TotDisc]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_ED850UOM]  DEFAULT (' ') FOR [ED850UOM]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_ED850UPC]  DEFAULT (' ') FOR [ED850UPC]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_EDIPOID]  DEFAULT (' ') FOR [EDIPOID]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_LineCounter]  DEFAULT ((0)) FOR [LineCounter]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_LineID]  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_Lupd_DateTime]  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_OrdNbr]  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_PODate]  DEFAULT ('01/01/1900') FOR [PODate]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_RI_ID]  DEFAULT ((0)) FOR [RI_ID]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_SODiscAmt]  DEFAULT ((0)) FOR [SODiscAmt]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_SOQty]  DEFAULT ((0)) FOR [SOQty]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_SOSlsExt]  DEFAULT ((0)) FOR [SOSlsExt]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_SOSlsNet]  DEFAULT ((0)) FOR [SOSlsNet]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDPORcvdWrk] ADD  CONSTRAINT [DF_EDPORcvdWrk_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
