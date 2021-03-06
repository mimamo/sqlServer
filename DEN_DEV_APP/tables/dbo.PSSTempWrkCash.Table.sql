USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSTempWrkCash]    Script Date: 12/21/2015 14:05:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSTempWrkCash](
	[AccessNbr] [char](4) NOT NULL,
	[FirstDay] [smalldatetime] NOT NULL,
	[Interest] [float] NOT NULL,
	[LastDay] [smalldatetime] NOT NULL,
	[LoanTypeCode] [char](10) NOT NULL,
	[MonthNbr] [smallint] NOT NULL,
	[Other] [float] NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[Principal] [float] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[Total] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSTempWrkCash] ADD  DEFAULT ('') FOR [AccessNbr]
GO
ALTER TABLE [dbo].[PSSTempWrkCash] ADD  DEFAULT ('01/01/1900') FOR [FirstDay]
GO
ALTER TABLE [dbo].[PSSTempWrkCash] ADD  DEFAULT ((0.00)) FOR [Interest]
GO
ALTER TABLE [dbo].[PSSTempWrkCash] ADD  DEFAULT ('01/01/1900') FOR [LastDay]
GO
ALTER TABLE [dbo].[PSSTempWrkCash] ADD  DEFAULT ('') FOR [LoanTypeCode]
GO
ALTER TABLE [dbo].[PSSTempWrkCash] ADD  DEFAULT ((0)) FOR [MonthNbr]
GO
ALTER TABLE [dbo].[PSSTempWrkCash] ADD  DEFAULT ((0.00)) FOR [Other]
GO
ALTER TABLE [dbo].[PSSTempWrkCash] ADD  DEFAULT ('') FOR [PerNbr]
GO
ALTER TABLE [dbo].[PSSTempWrkCash] ADD  DEFAULT ((0.00)) FOR [Principal]
GO
ALTER TABLE [dbo].[PSSTempWrkCash] ADD  DEFAULT ((0)) FOR [RI_ID]
GO
ALTER TABLE [dbo].[PSSTempWrkCash] ADD  DEFAULT ((0.00)) FOR [Total]
GO
