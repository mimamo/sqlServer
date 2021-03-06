USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSTmpLLGenAPVO]    Script Date: 12/21/2015 16:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSTmpLLGenAPVO](
	[AcctIPPCr] [char](10) NOT NULL,
	[AcctIPPDr] [char](10) NOT NULL,
	[AcctNo] [char](20) NOT NULL,
	[AcctPPRCr] [char](10) NOT NULL,
	[AcctPPRDr] [char](10) NOT NULL,
	[AcctWPRCr] [char](10) NOT NULL,
	[AcctWPRDr] [char](10) NOT NULL,
	[APBatNbr] [char](10) NOT NULL,
	[APRefNbr] [char](10) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DueAmt] [float] NOT NULL,
	[DueDate] [smalldatetime] NOT NULL,
	[Interest] [float] NOT NULL,
	[LineId] [smallint] NOT NULL,
	[LoanName] [char](60) NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[LoanTypeCode] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Other] [float] NOT NULL,
	[Pjt_Entity] [char](32) NOT NULL,
	[PmtNbr] [smallint] NOT NULL,
	[Principal] [float] NOT NULL,
	[Process] [smallint] NOT NULL,
	[Project] [char](16) NOT NULL,
	[Relation] [char](6) NOT NULL,
	[SubIPPCr] [char](24) NOT NULL,
	[SubIPPDr] [char](24) NOT NULL,
	[SubPPRCr] [char](24) NOT NULL,
	[SubPPRDr] [char](24) NOT NULL,
	[SubWPRCr] [char](24) NOT NULL,
	[SubWPRDr] [char](24) NOT NULL,
	[UnpaidCharges] [float] NOT NULL,
	[UnPaidEscrow] [float] NOT NULL,
	[UnPaidIntCharges] [float] NOT NULL,
	[UnPaidLateFee] [float] NOT NULL,
	[UnPaidLateInt] [float] NOT NULL,
	[UnPaidLateIntOnInt] [float] NOT NULL,
	[UnPaidLIOLI] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendID] [char](15) NOT NULL,
	[VendName] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [AcctIPPCr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [AcctIPPDr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [AcctNo]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [AcctPPRCr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [AcctPPRDr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [AcctWPRCr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [AcctWPRDr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [APBatNbr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [APRefNbr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0.00)) FOR [DueAmt]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('01/01/1900') FOR [DueDate]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0.00)) FOR [Interest]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [LoanName]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [LoanTypeCode]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0.00)) FOR [Other]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [Pjt_Entity]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0)) FOR [PmtNbr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0.00)) FOR [Principal]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0)) FOR [Process]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [Project]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [Relation]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [SubIPPCr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [SubIPPDr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [SubPPRCr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [SubPPRDr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [SubWPRCr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [SubWPRDr]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0.00)) FOR [UnpaidCharges]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0.00)) FOR [UnPaidEscrow]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0.00)) FOR [UnPaidIntCharges]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0.00)) FOR [UnPaidLateFee]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0.00)) FOR [UnPaidLateInt]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0.00)) FOR [UnPaidLateIntOnInt]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0.00)) FOR [UnPaidLIOLI]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [VendID]
GO
ALTER TABLE [dbo].[PSSTmpLLGenAPVO] ADD  DEFAULT ('') FOR [VendName]
GO
