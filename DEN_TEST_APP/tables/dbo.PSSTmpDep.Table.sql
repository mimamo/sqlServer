USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSTmpDep]    Script Date: 12/21/2015 14:10:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSTmpDep](
	[AccNo] [char](20) NOT NULL,
	[AcctId] [char](10) NOT NULL,
	[Amt01] [float] NOT NULL,
	[Amt02] [float] NOT NULL,
	[Amt03] [float] NOT NULL,
	[Amt04] [float] NOT NULL,
	[Amt05] [float] NOT NULL,
	[Amt06] [float] NOT NULL,
	[Amt07] [float] NOT NULL,
	[Amt08] [float] NOT NULL,
	[Amt09] [float] NOT NULL,
	[Amt10] [float] NOT NULL,
	[Amt11] [float] NOT NULL,
	[Amt12] [float] NOT NULL,
	[Amt13] [float] NOT NULL,
	[Amt14] [float] NOT NULL,
	[Amt15] [float] NOT NULL,
	[Amt16] [float] NOT NULL,
	[Amt17] [float] NOT NULL,
	[Amt18] [float] NOT NULL,
	[CustodianCode] [char](6) NOT NULL,
	[Desc01] [char](60) NOT NULL,
	[Desc02] [char](60) NOT NULL,
	[Desc03] [char](60) NOT NULL,
	[Desc04] [char](60) NOT NULL,
	[Desc05] [char](60) NOT NULL,
	[Desc06] [char](60) NOT NULL,
	[Desc07] [char](60) NOT NULL,
	[Desc08] [char](60) NOT NULL,
	[Desc09] [char](60) NOT NULL,
	[Desc10] [char](60) NOT NULL,
	[Desc11] [char](60) NOT NULL,
	[Desc12] [char](60) NOT NULL,
	[Desc13] [char](60) NOT NULL,
	[Desc14] [char](60) NOT NULL,
	[Desc15] [char](60) NOT NULL,
	[Desc16] [char](60) NOT NULL,
	[Desc17] [char](60) NOT NULL,
	[Desc18] [char](60) NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [AccNo]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [AcctId]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt01]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt02]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt03]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt04]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt05]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt06]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt07]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt08]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt09]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt10]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt11]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt12]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt13]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt14]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt15]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt16]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt17]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ((0.00)) FOR [Amt18]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [CustodianCode]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc01]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc02]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc03]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc04]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc05]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc06]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc07]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc08]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc09]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc10]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc11]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc12]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc13]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc14]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc15]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc16]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc17]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [Desc18]
GO
ALTER TABLE [dbo].[PSSTmpDep] ADD  DEFAULT ('') FOR [RefNbr]
GO
