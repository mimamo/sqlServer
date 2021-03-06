USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tGLAccountRecUnmatched]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tGLAccountRecUnmatched](
	[GLAccountRecUnmatchedKey] [int] NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[GLAccountKey] [int] NOT NULL,
	[GLCompanyKey] [int] NULL,
	[Reference] [varchar](500) NULL,
	[TransactionDate] [smalldatetime] NULL,
	[Amount] [money] NULL,
	[Memo] [text] NULL,
	[Entity] [varchar](50) NULL,
	[EntityKey] [int] NULL,
 CONSTRAINT [PK_tGLAccountRecUnmatched] PRIMARY KEY CLUSTERED 
(
	[GLAccountRecUnmatchedKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
