USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSystemMessageUser]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tSystemMessageUser](
	[SystemMessageKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[DateViewed] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tSystemMessageUser] PRIMARY KEY CLUSTERED 
(
	[SystemMessageKey] ASC,
	[UserKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
