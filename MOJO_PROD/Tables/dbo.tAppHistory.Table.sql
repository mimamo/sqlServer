USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tAppHistory]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tAppHistory](
	[CompanyKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[ActionID] [varchar](50) NULL,
	[ActionKey] [int] NULL,
	[Label] [varchar](500) NULL,
	[DateAdded] [smalldatetime] NOT NULL,
	[Section] [varchar](50) NULL,
	[Description] [varchar](500) NULL,
	[Icon] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tAppHistory] ADD  CONSTRAINT [DF_tAppHistory_DateAdded]  DEFAULT (getutcdate()) FOR [DateAdded]
GO
