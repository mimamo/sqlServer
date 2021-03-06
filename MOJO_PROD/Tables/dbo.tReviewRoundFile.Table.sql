USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tReviewRoundFile]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tReviewRoundFile](
	[ReviewRoundKey] [int] NULL,
	[FilePath] [varchar](1000) NULL,
	[IsURL] [tinyint] NULL,
	[DisplayOrder] [int] NULL,
	[ReviewRoundFileKey] [int] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](100) NULL,
	[PageCount] [int] NULL,
 CONSTRAINT [PK_tReviewRoundFile] PRIMARY KEY CLUSTERED 
(
	[ReviewRoundFileKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tReviewRoundFile]  WITH CHECK ADD  CONSTRAINT [FK_tReviewRoundFile_tReviewRound] FOREIGN KEY([ReviewRoundKey])
REFERENCES [dbo].[tReviewRound] ([ReviewRoundKey])
GO
ALTER TABLE [dbo].[tReviewRoundFile] CHECK CONSTRAINT [FK_tReviewRoundFile_tReviewRound]
GO
