USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PRSetup]    Script Date: 12/21/2015 13:56:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PRSetup](
	[APBatDflt] [char](1) NOT NULL,
	[APUpd] [smallint] NOT NULL,
	[APUpdRel] [smallint] NOT NULL,
	[Box17LIncl] [smallint] NOT NULL,
	[Box17LLmt] [float] NOT NULL,
	[Box22Incl] [smallint] NOT NULL,
	[CalYr] [char](4) NOT NULL,
	[ChkAcct] [char](10) NOT NULL,
	[ChkSub] [char](24) NOT NULL,
	[ComputerManuf] [char](8) NOT NULL,
	[CovGrpNbr] [smallint] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrCalYr] [char](4) NOT NULL,
	[DirectDeposit] [char](1) NOT NULL,
	[DPRateMult] [smallint] NOT NULL,
	[DPUnits] [smallint] NOT NULL,
	[EmpIdToGL] [smallint] NOT NULL,
	[EmpmtType] [char](1) NOT NULL,
	[EmpRGP] [char](6) NOT NULL,
	[EstabPlanNbr] [char](4) NOT NULL,
	[ExpAcct] [char](10) NOT NULL,
	[ExpSub] [char](24) NOT NULL,
	[FedHrlyMinWage] [float] NOT NULL,
	[GLPostOpt] [char](1) NOT NULL,
	[Init] [smallint] NOT NULL,
	[LastBatNbr] [char](10) NOT NULL,
	[LmtLiab] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MagW2] [smallint] NOT NULL,
	[MaxDec] [smallint] NOT NULL,
	[MCTimeEntry] [smallint] NOT NULL,
	[MinWageMultiplier] [float] NOT NULL,
	[MultChkPay] [char](1) NOT NULL,
	[NextCheckDate] [smalldatetime] NOT NULL,
	[NoteId] [int] NOT NULL,
	[PercentDispEarn] [float] NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PerRetStubDtl] [smallint] NOT NULL,
	[ProjCostUpdFlag] [char](1) NOT NULL,
	[RetChkRcncl] [smallint] NOT NULL,
	[RetDeductHist] [smallint] NOT NULL,
	[RetPerTimesheets] [smallint] NOT NULL,
	[RetQtrChecks] [smallint] NOT NULL,
	[RetYrsEmpHist] [smallint] NOT NULL,
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
	[SalaryChkSeq] [char](2) NOT NULL,
	[SetupId] [char](2) NOT NULL,
	[StateLocNbr] [char](9) NOT NULL,
	[UnitNbr] [char](3) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WCExpAcct] [char](10) NOT NULL,
	[WCLibAcct] [char](10) NOT NULL,
	[WCLibSub] [char](24) NOT NULL,
	[WCPostToGL] [smallint] NOT NULL,
	[WCSubSrc] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PRSetup0] PRIMARY KEY CLUSTERED 
(
	[SetupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_APBatDflt]  DEFAULT (' ') FOR [APBatDflt]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_APUpd]  DEFAULT ((0)) FOR [APUpd]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_APUpdRel]  DEFAULT ((0)) FOR [APUpdRel]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_Box17LIncl]  DEFAULT ((0)) FOR [Box17LIncl]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_Box17LLmt]  DEFAULT ((0)) FOR [Box17LLmt]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_Box22Incl]  DEFAULT ((0)) FOR [Box22Incl]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_CalYr]  DEFAULT (' ') FOR [CalYr]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_ChkAcct]  DEFAULT (' ') FOR [ChkAcct]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_ChkSub]  DEFAULT (' ') FOR [ChkSub]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_ComputerManuf]  DEFAULT (' ') FOR [ComputerManuf]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_CovGrpNbr]  DEFAULT ((0)) FOR [CovGrpNbr]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_CurrCalYr]  DEFAULT (' ') FOR [CurrCalYr]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_DirectDeposit]  DEFAULT (' ') FOR [DirectDeposit]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_DPRateMult]  DEFAULT ((0)) FOR [DPRateMult]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_DPUnits]  DEFAULT ((0)) FOR [DPUnits]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_EmpIdToGL]  DEFAULT ((0)) FOR [EmpIdToGL]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_EmpmtType]  DEFAULT (' ') FOR [EmpmtType]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_EmpRGP]  DEFAULT (' ') FOR [EmpRGP]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_EstabPlanNbr]  DEFAULT (' ') FOR [EstabPlanNbr]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_ExpAcct]  DEFAULT (' ') FOR [ExpAcct]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_ExpSub]  DEFAULT (' ') FOR [ExpSub]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_FedHrlyMinWage]  DEFAULT ((0)) FOR [FedHrlyMinWage]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_GLPostOpt]  DEFAULT (' ') FOR [GLPostOpt]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_Init]  DEFAULT ((0)) FOR [Init]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_LastBatNbr]  DEFAULT (' ') FOR [LastBatNbr]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_LmtLiab]  DEFAULT ((0)) FOR [LmtLiab]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_MagW2]  DEFAULT ((0)) FOR [MagW2]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_MaxDec]  DEFAULT ((0)) FOR [MaxDec]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_MCTimeEntry]  DEFAULT ((0)) FOR [MCTimeEntry]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_MinWageMultiplier]  DEFAULT ((0)) FOR [MinWageMultiplier]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_MultChkPay]  DEFAULT (' ') FOR [MultChkPay]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_NextCheckDate]  DEFAULT ('01/01/1900') FOR [NextCheckDate]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_NoteId]  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_PercentDispEarn]  DEFAULT ((0)) FOR [PercentDispEarn]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_PerNbr]  DEFAULT (' ') FOR [PerNbr]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_PerRetStubDtl]  DEFAULT ((0)) FOR [PerRetStubDtl]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_ProjCostUpdFlag]  DEFAULT (' ') FOR [ProjCostUpdFlag]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_RetChkRcncl]  DEFAULT ((0)) FOR [RetChkRcncl]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_RetDeductHist]  DEFAULT ((0)) FOR [RetDeductHist]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_RetPerTimesheets]  DEFAULT ((0)) FOR [RetPerTimesheets]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_RetQtrChecks]  DEFAULT ((0)) FOR [RetQtrChecks]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_RetYrsEmpHist]  DEFAULT ((0)) FOR [RetYrsEmpHist]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_SalaryChkSeq]  DEFAULT (' ') FOR [SalaryChkSeq]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_SetupId]  DEFAULT (' ') FOR [SetupId]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_StateLocNbr]  DEFAULT (' ') FOR [StateLocNbr]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_UnitNbr]  DEFAULT (' ') FOR [UnitNbr]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_WCExpAcct]  DEFAULT (' ') FOR [WCExpAcct]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_WCLibAcct]  DEFAULT (' ') FOR [WCLibAcct]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_WCLibSub]  DEFAULT (' ') FOR [WCLibSub]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_WCPostToGL]  DEFAULT ((0)) FOR [WCPostToGL]
GO
ALTER TABLE [dbo].[PRSetup] ADD  CONSTRAINT [DF_PRSetup_WCSubSrc]  DEFAULT (' ') FOR [WCSubSrc]
GO
