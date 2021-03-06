USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tReviewComment]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tReviewComment](
	[ReviewCommentKey] [int] IDENTITY(1,1) NOT NULL,
	[ReviewRoundKey] [int] NOT NULL,
	[ApprovalStepKey] [int] NULL,
	[ParentCommentKey] [int] NULL,
	[UserKey] [int] NULL,
	[Page] [int] NULL,
	[UserName] [varchar](1000) NULL,
	[Comment] [text] NULL,
	[DateAdded] [smalldatetime] NULL,
	[Position] [int] NULL,
	[FixThis] [tinyint] NULL,
	[FixedDate] [datetime] NULL,
	[URL] [varchar](2000) NULL,
	[ReviewRoundFileKey] [int] NULL,
 CONSTRAINT [PK_tReviewComment] PRIMARY KEY CLUSTERED 
(
	[ReviewCommentKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tReviewComment]  WITH CHECK ADD  CONSTRAINT [FK_tReviewComment_tApprovalStep] FOREIGN KEY([ApprovalStepKey])
REFERENCES [dbo].[tApprovalStep] ([ApprovalStepKey])
GO
ALTER TABLE [dbo].[tReviewComment] CHECK CONSTRAINT [FK_tReviewComment_tApprovalStep]
GO
ALTER TABLE [dbo].[tReviewComment]  WITH CHECK ADD  CONSTRAINT [FK_tReviewComment_tReviewRound] FOREIGN KEY([ReviewRoundKey])
REFERENCES [dbo].[tReviewRound] ([ReviewRoundKey])
GO
ALTER TABLE [dbo].[tReviewComment] CHECK CONSTRAINT [FK_tReviewComment_tReviewRound]
GO
