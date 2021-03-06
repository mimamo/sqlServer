USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[LCVoucher]    Script Date: 12/21/2015 15:42:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LCVoucher](
	[AddlCost] [float] NOT NULL,
	[AddlCostPct] [float] NOT NULL,
	[AllocMethod] [char](1) NOT NULL,
	[APBatNbr] [char](10) NOT NULL,
	[APLineID] [int] NOT NULL,
	[APLineRef] [char](5) NOT NULL,
	[APRefNbr] [char](10) NOT NULL,
	[BMICuryID] [char](4) NOT NULL,
	[BMIEffDate] [smalldatetime] NOT NULL,
	[BMIExtCost] [float] NOT NULL,
	[BMIMultDiv] [char](1) NOT NULL,
	[BMIRate] [float] NOT NULL,
	[BMIRtTp] [char](6) NOT NULL,
	[BMITranAmt] [float] NOT NULL,
	[BMIUnitCost] [float] NOT NULL,
	[BMIUnitPrice] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryAddlCost] [float] NOT NULL,
	[CuryExtCost] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryTranAmt] [float] NOT NULL,
	[CuryUnitCost] [float] NOT NULL,
	[ExtCost] [float] NOT NULL,
	[ExtVolume] [float] NOT NULL,
	[ExtWeight] [float] NOT NULL,
	[InvAdjBatNbr] [char](10) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LCCode] [char](10) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrigSiteID] [char](10) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[RcptDate] [smalldatetime] NOT NULL,
	[RcptNbr] [char](10) NOT NULL,
	[RcptQty] [float] NOT NULL,
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
	[SpecificCostID] [char](25) NOT NULL,
	[TranStatus] [char](1) NOT NULL,
	[UnitDescr] [char](6) NOT NULL,
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
	[UserSpecPct] [float] NOT NULL,
	[ValMthd] [char](1) NOT NULL,
	[VendID] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_AddlCost]  DEFAULT ((0)) FOR [AddlCost]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_AddlCostPct]  DEFAULT ((0)) FOR [AddlCostPct]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_AllocMethod]  DEFAULT (' ') FOR [AllocMethod]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_APBatNbr]  DEFAULT (' ') FOR [APBatNbr]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_APLineID]  DEFAULT ((0)) FOR [APLineID]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_APLineRef]  DEFAULT (' ') FOR [APLineRef]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_APRefNbr]  DEFAULT (' ') FOR [APRefNbr]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_BMICuryID]  DEFAULT (' ') FOR [BMICuryID]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_BMIEffDate]  DEFAULT ('01/01/1900') FOR [BMIEffDate]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_BMIExtCost]  DEFAULT ((0)) FOR [BMIExtCost]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_BMIMultDiv]  DEFAULT (' ') FOR [BMIMultDiv]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_BMIRate]  DEFAULT ((0)) FOR [BMIRate]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_BMIRtTp]  DEFAULT (' ') FOR [BMIRtTp]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_BMITranAmt]  DEFAULT ((0)) FOR [BMITranAmt]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_BMIUnitCost]  DEFAULT ((0)) FOR [BMIUnitCost]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_BMIUnitPrice]  DEFAULT ((0)) FOR [BMIUnitPrice]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_CuryAddlCost]  DEFAULT ((0)) FOR [CuryAddlCost]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_CuryExtCost]  DEFAULT ((0)) FOR [CuryExtCost]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_CuryMultDiv]  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_CuryRate]  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_CuryTranAmt]  DEFAULT ((0)) FOR [CuryTranAmt]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_CuryUnitCost]  DEFAULT ((0)) FOR [CuryUnitCost]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_ExtCost]  DEFAULT ((0)) FOR [ExtCost]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_ExtVolume]  DEFAULT ((0)) FOR [ExtVolume]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_ExtWeight]  DEFAULT ((0)) FOR [ExtWeight]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_InvAdjBatNbr]  DEFAULT (' ') FOR [InvAdjBatNbr]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_LCCode]  DEFAULT (' ') FOR [LCCode]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_OrigSiteID]  DEFAULT (' ') FOR [OrigSiteID]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_PONbr]  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_RcptDate]  DEFAULT ('01/01/1900') FOR [RcptDate]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_RcptNbr]  DEFAULT (' ') FOR [RcptNbr]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_RcptQty]  DEFAULT ((0)) FOR [RcptQty]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_SpecificCostID]  DEFAULT (' ') FOR [SpecificCostID]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_TranStatus]  DEFAULT (' ') FOR [TranStatus]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_UnitDescr]  DEFAULT (' ') FOR [UnitDescr]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_UserSpecPct]  DEFAULT ((0)) FOR [UserSpecPct]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_ValMthd]  DEFAULT (' ') FOR [ValMthd]
GO
ALTER TABLE [dbo].[LCVoucher] ADD  CONSTRAINT [DF_LCVoucher_VendID]  DEFAULT (' ') FOR [VendID]
GO
