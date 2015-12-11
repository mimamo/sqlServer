USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaStdComment]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaStdComment](
	[MediaStdCommentKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NULL,
	[CommentID] [varchar](50) NULL,
	[Comment] [varchar](4000) NULL,
	[POKind] [smallint] NULL,
	[Active] [smallint] NOT NULL,
 CONSTRAINT [PK_tMediaStdComment] PRIMARY KEY CLUSTERED 
(
	[MediaStdCommentKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMediaStdComment] ADD  CONSTRAINT [DF_tMediaStdComment_Active]  DEFAULT ((1)) FOR [Active]
GO
