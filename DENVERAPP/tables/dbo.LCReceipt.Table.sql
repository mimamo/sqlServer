USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[LCReceipt]    Script Date: 12/21/2015 15:42:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LCReceipt](
	[AllocMethod] [char](1) NOT NULL,
	[APRefNbr] [char](10) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BMIExtCost] [float] NOT NULL,
	[BMIFlag] [smallint] NOT NULL,
	[BMIMultDiv] [char](1) NOT NULL,
	[BMIRate] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryDocAmt] [float] NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[DocAmt] [float] NOT NULL,
	[INBatNbr] [char](10) NOT NULL,
	[InvcDate] [smalldatetime] NOT NULL,
	[InvcNbr] [char](15) NOT NULL,
	[LCCode] [char](10) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[RcptNbr] [char](10) NOT NULL,
	[ReasonCd] [char](6) NOT NULL,
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
	[TermsID] [char](2) NOT NULL,
	[TranStatus] [char](1) NOT NULL,
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
	[VendID] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_AllocMethod]  DEFAULT (' ') FOR [AllocMethod]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_APRefNbr]  DEFAULT (' ') FOR [APRefNbr]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_BatNbr]  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_BMIExtCost]  DEFAULT ((0)) FOR [BMIExtCost]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_BMIFlag]  DEFAULT ((0)) FOR [BMIFlag]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_BMIMultDiv]  DEFAULT (' ') FOR [BMIMultDiv]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_BMIRate]  DEFAULT ((0)) FOR [BMIRate]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_CuryDocAmt]  DEFAULT ((0)) FOR [CuryDocAmt]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_CuryEffDate]  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_CuryMultDiv]  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_CuryRate]  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_CuryRateType]  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_DocAmt]  DEFAULT ((0)) FOR [DocAmt]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_INBatNbr]  DEFAULT (' ') FOR [INBatNbr]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_InvcDate]  DEFAULT ('01/01/1900') FOR [InvcDate]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_InvcNbr]  DEFAULT (' ') FOR [InvcNbr]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_LCCode]  DEFAULT (' ') FOR [LCCode]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_PerPost]  DEFAULT (' ') FOR [PerPost]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_PONbr]  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_RcptNbr]  DEFAULT (' ') FOR [RcptNbr]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_ReasonCd]  DEFAULT (' ') FOR [ReasonCd]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_TermsID]  DEFAULT (' ') FOR [TermsID]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_TranStatus]  DEFAULT (' ') FOR [TranStatus]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_UserSpecPct]  DEFAULT ((0)) FOR [UserSpecPct]
GO
ALTER TABLE [dbo].[LCReceipt] ADD  CONSTRAINT [DF_LCReceipt_VendID]  DEFAULT (' ') FOR [VendID]
GO
