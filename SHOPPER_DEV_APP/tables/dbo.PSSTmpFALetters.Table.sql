USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSTmpFALetters]    Script Date: 12/21/2015 14:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSTmpFALetters](
	[AccessNbr] [smallint] NOT NULL,
	[AssetID] [char](10) NOT NULL,
	[AssetSubID] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSTmpFALetters] ADD  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[PSSTmpFALetters] ADD  DEFAULT ('') FOR [AssetID]
GO
ALTER TABLE [dbo].[PSSTmpFALetters] ADD  DEFAULT ('') FOR [AssetSubID]
GO
