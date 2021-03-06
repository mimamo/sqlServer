USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tRight]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tRight](
	[RightKey] [int] NOT NULL,
	[RightID] [varchar](35) NOT NULL,
	[Description] [varchar](100) NULL,
	[RightGroup] [varchar](35) NOT NULL,
	[SetGroup] [varchar](35) NULL,
	[DisplayOrder] [int] NULL,
	[CPM] [tinyint] NULL,
 CONSTRAINT [tRight_PK] PRIMARY KEY CLUSTERED 
(
	[RightKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
