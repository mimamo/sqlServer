USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tReviewCommentMarkup]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tReviewCommentMarkup](
	[ReviewCommentMarkupKey] [int] IDENTITY(1,1) NOT NULL,
	[ReviewCommentKey] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[X0] [int] NOT NULL,
	[Y0] [int] NOT NULL,
	[X1] [int] NOT NULL,
	[Y1] [int] NOT NULL,
	[LineWidth] [int] NOT NULL,
	[StrokeStyle] [varchar](50) NULL,
	[FillStyle] [varchar](50) NULL,
	[Style] [varchar](50) NULL,
	[MarkupData] [varchar](max) NULL,
 CONSTRAINT [PK_tReviewCommentMarkup] PRIMARY KEY CLUSTERED 
(
	[ReviewCommentMarkupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tReviewCommentMarkup]  WITH CHECK ADD  CONSTRAINT [FK_tReviewCommentMarkup_tReviewComment] FOREIGN KEY([ReviewCommentKey])
REFERENCES [dbo].[tReviewComment] ([ReviewCommentKey])
GO
ALTER TABLE [dbo].[tReviewCommentMarkup] CHECK CONSTRAINT [FK_tReviewCommentMarkup_tReviewComment]
GO
