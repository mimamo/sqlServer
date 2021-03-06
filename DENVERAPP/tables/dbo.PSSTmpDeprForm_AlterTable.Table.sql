USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[PSSTmpDeprForm_AlterTable]    Script Date: 12/21/2015 15:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSTmpDeprForm_AlterTable](
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
ALTER TABLE [dbo].[PSSTmpDeprForm_AlterTable] ADD  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[PSSTmpDeprForm_AlterTable] ADD  DEFAULT ((0.00)) FOR [Amount]
GO
ALTER TABLE [dbo].[PSSTmpDeprForm_AlterTable] ADD  DEFAULT ('') FOR [Code]
GO
ALTER TABLE [dbo].[PSSTmpDeprForm_AlterTable] ADD  DEFAULT ('') FOR [Form]
GO
ALTER TABLE [dbo].[PSSTmpDeprForm_AlterTable] ADD  DEFAULT ('') FOR [StartYear]
GO
