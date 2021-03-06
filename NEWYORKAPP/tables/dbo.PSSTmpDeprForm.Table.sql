USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[PSSTmpDeprForm]    Script Date: 12/21/2015 16:00:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSTmpDeprForm](
	[AccessNbr] [smallint] NOT NULL,
	[Amount] [float] NOT NULL,
	[Code] [char](15) NOT NULL,
	[Form] [char](10) NOT NULL,
	[StartYear] [char](4) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSTmpDeprForm] ADD  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[PSSTmpDeprForm] ADD  DEFAULT ((0.00)) FOR [Amount]
GO
ALTER TABLE [dbo].[PSSTmpDeprForm] ADD  DEFAULT ('') FOR [Code]
GO
ALTER TABLE [dbo].[PSSTmpDeprForm] ADD  DEFAULT ('') FOR [Form]
GO
ALTER TABLE [dbo].[PSSTmpDeprForm] ADD  DEFAULT ('') FOR [StartYear]
GO
