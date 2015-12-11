USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tActionLog]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tActionLog](
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[CompanyKey] [int] NULL,
	[ProjectKey] [int] NULL,
	[Action] [varchar](200) NOT NULL,
	[ActionDate] [smalldatetime] NOT NULL,
	[ActionBy] [varchar](500) NULL,
	[Comments] [varchar](4000) NULL,
	[Reference] [varchar](200) NULL,
	[SourceCompanyID] [varchar](100) NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[UserKey] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tActionLog] ADD  CONSTRAINT [DF_tActionLog_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
