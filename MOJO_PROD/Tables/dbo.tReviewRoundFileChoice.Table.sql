USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tReviewRoundFileChoice]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tReviewRoundFileChoice](
	[ReviewRoundFileKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[Choice] [smallint] NOT NULL,
 CONSTRAINT [PK_tReviewRoundFileChoice] PRIMARY KEY CLUSTERED 
(
	[ReviewRoundFileKey] ASC,
	[UserKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
