USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tActivityHistory]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tActivityHistory](
	[ActivityKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[ActivityDate] [smalldatetime] NOT NULL,
	[Notes] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
