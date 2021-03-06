USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProjectCreativeBrief]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tProjectCreativeBrief](
	[ProjectKey] [int] NOT NULL,
	[Subject1] [varchar](200) NULL,
	[Description1] [text] NULL,
	[Subject2] [varchar](200) NULL,
	[Description2] [text] NULL,
	[Subject3] [varchar](200) NULL,
	[Description3] [text] NULL,
	[Subject4] [varchar](200) NULL,
	[Description4] [text] NULL,
	[Subject5] [varchar](200) NULL,
	[Description5] [text] NULL,
	[Subject6] [varchar](200) NULL,
	[Description6] [text] NULL,
	[Subject7] [varchar](200) NULL,
	[Description7] [text] NULL,
	[Subject8] [varchar](200) NULL,
	[Description8] [text] NULL,
	[Subject9] [varchar](200) NULL,
	[Description9] [text] NULL,
	[Subject10] [varchar](200) NULL,
	[Description10] [text] NULL,
	[Subject11] [varchar](200) NULL,
	[Description11] [text] NULL,
	[Subject12] [varchar](200) NULL,
	[Description12] [text] NULL,
 CONSTRAINT [PK_tProjectCreativeBrief] PRIMARY KEY NONCLUSTERED 
(
	[ProjectKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
