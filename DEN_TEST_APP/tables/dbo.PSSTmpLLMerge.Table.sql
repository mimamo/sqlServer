USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSTmpLLMerge]    Script Date: 12/21/2015 14:10:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSTmpLLMerge](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MergeChrg] [float] NOT NULL,
	[MergeInt] [float] NOT NULL,
	[MergePrin] [float] NOT NULL,
	[MrgChrgYN] [int] NOT NULL,
	[MrgIntYN] [int] NOT NULL,
	[MrgPrinYN] [int] NOT NULL,
	[NewChrg] [float] NOT NULL,
	[NewInt] [float] NOT NULL,
	[NewPrin] [float] NOT NULL,
	[UnpaidChrg] [float] NOT NULL,
	[UnpaidInt] [float] NOT NULL,
	[UnpaidPrin] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WOChrgAcct] [char](10) NOT NULL,
	[WOChrgSub] [char](24) NOT NULL,
	[WOIntAcct] [char](10) NOT NULL,
	[WOIntSub] [char](24) NOT NULL,
	[WOPrinAcct] [char](10) NOT NULL,
	[WOPrinSub] [char](24) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0.00)) FOR [MergeChrg]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0.00)) FOR [MergeInt]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0.00)) FOR [MergePrin]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0)) FOR [MrgChrgYN]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0)) FOR [MrgIntYN]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0)) FOR [MrgPrinYN]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0.00)) FOR [NewChrg]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0.00)) FOR [NewInt]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0.00)) FOR [NewPrin]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0.00)) FOR [UnpaidChrg]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0.00)) FOR [UnpaidInt]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0.00)) FOR [UnpaidPrin]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [WOChrgAcct]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [WOChrgSub]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [WOIntAcct]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [WOIntSub]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [WOPrinAcct]
GO
ALTER TABLE [dbo].[PSSTmpLLMerge] ADD  DEFAULT ('') FOR [WOPrinSub]
GO
