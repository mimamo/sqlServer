USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSTmpFALetters_AlterTable]    Script Date: 12/21/2015 13:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSTmpFALetters_AlterTable](
	[AccessNbr] [smallint] NOT NULL,
	[AssetID] [char](10) NOT NULL,
	[AssetSubID] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSTmpFALetters_AlterTable] ADD  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[PSSTmpFALetters_AlterTable] ADD  DEFAULT ('') FOR [AssetID]
GO
ALTER TABLE [dbo].[PSSTmpFALetters_AlterTable] ADD  DEFAULT ('') FOR [AssetSubID]
GO
