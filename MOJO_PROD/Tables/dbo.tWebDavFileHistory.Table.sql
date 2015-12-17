USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tWebDavFileHistory]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tWebDavFileHistory](
	[FileKey] [uniqueidentifier] NOT NULL,
	[Modified] [smalldatetime] NULL,
	[ModifiedBy] [int] NULL,
	[FileSize] [bigint] NULL,
	[Comments] [text] NULL,
	[Action] [smallint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
