USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tComment]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tComment](
	[CommentKey] [int] IDENTITY(1,1) NOT NULL,
	[FileRevisionKey] [int] NOT NULL,
	[Subject] [varchar](50) NOT NULL,
	[DateAdded] [datetime] NOT NULL,
	[Comments] [varchar](250) NULL,
	[OriginalFileName] [varchar](255) NOT NULL,
 CONSTRAINT [PK_tComment] PRIMARY KEY NONCLUSTERED 
(
	[CommentKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
