USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[POReceipt]    Script Date: 12/21/2015 14:26:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POReceipt](
	[APRefno] [char](10) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CreateAD] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryFreight] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryRcptAmt] [float] NOT NULL,
	[CuryRcptAmtTot] [float] NOT NULL,
	[CuryRcptCtrlAmt] [float] NOT NULL,
	[CuryRcptItemTotal] [float] NOT NULL,
	[DfltFromPO] [char](1) NOT NULL,
	[Freight] [float] NOT NULL,
	[InBal] [smallint] NOT NULL,
	[LineCntr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OpenDoc] [smallint] NOT NULL,
	[PC_Status] [char](1) NOT NULL,
	[PerClosed] [char](6) NOT NULL,
	[PerEnt] [char](6) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[RcptAmt] [float] NOT NULL,
	[RcptAmtTot] [float] NOT NULL,
	[RcptCtrlAmt] [float] NOT NULL,
	[RcptCtrlQty] [float] NOT NULL,
	[RcptDate] [smalldatetime] NOT NULL,
	[RcptItemTotal] [float] NOT NULL,
	[RcptNbr] [char](10) NOT NULL,
	[RcptQty] [float] NOT NULL,
	[RcptQtyTot] [float] NOT NULL,
	[RcptType] [char](1) NOT NULL,
	[ReopenPO] [smallint] NOT NULL,
	[Rlsed] [smallint] NOT NULL,
	[RMAID] [char](15) NOT NULL,
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
	[ServiceCallID] [char](10) NOT NULL,
	[ShipperID] [char](15) NOT NULL,
	[Status] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendID] [char](15) NOT NULL,
	[VendInvcNbr] [char](10) NOT NULL,
	[VouchStage] [char](1) NOT NULL,
	[WayBillNbr] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [APRefno]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [CreateAD]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [CuryFreight]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [CuryRcptAmt]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [CuryRcptAmtTot]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [CuryRcptCtrlAmt]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [CuryRcptItemTotal]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [DfltFromPO]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [Freight]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [InBal]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [LineCntr]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [OpenDoc]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [PC_Status]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [PerClosed]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [PerEnt]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [RcptAmt]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [RcptAmtTot]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [RcptCtrlAmt]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [RcptCtrlQty]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ('01/01/1900') FOR [RcptDate]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [RcptItemTotal]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [RcptNbr]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [RcptQty]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [RcptQtyTot]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [RcptType]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [ReopenPO]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [Rlsed]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [RMAID]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [ServiceCallID]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [VendID]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [VendInvcNbr]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [VouchStage]
GO
ALTER TABLE [dbo].[POReceipt] ADD  DEFAULT (' ') FOR [WayBillNbr]
GO
