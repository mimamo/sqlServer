USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tRelease]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tRelease](
	[ReleaseKey] [int] NOT NULL,
	[ReleaseID] [varchar](50) NULL,
	[DateInstalled] [datetime] NULL,
	[LogText] [text] NULL,
 CONSTRAINT [PK_tRelease] PRIMARY KEY CLUSTERED 
(
	[ReleaseKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
