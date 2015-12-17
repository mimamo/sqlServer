USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tReviewLog]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tReviewLog](
	[ReviewDeliverableKey] [int] NULL,
	[ReviewRoundKey] [int] NULL,
	[ReviewStageKey] [int] NULL,
	[UserName] [varchar](1000) NULL,
	[Email] [varchar](1000) NULL,
	[DateAdded] [smalldatetime] NULL,
	[Notes] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
