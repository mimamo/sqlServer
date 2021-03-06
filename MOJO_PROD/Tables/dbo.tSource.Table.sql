USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSource]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSource](
	[SourceKey] [int] IDENTITY(1,1) NOT NULL,
	[SourceName] [varchar](200) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Active] [tinyint] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tSource] ADD  CONSTRAINT [DF_tSource_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[tSource] ADD  CONSTRAINT [DF_tSource_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
