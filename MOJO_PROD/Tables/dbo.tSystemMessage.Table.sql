USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSystemMessage]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSystemMessage](
	[SystemMessageKey] [int] IDENTITY(1,1) NOT NULL,
	[Active] [tinyint] NOT NULL,
	[SecurityRight] [varchar](50) NULL,
	[AdminOnly] [tinyint] NULL,
	[MessageText] [text] NULL,
	[InactiveDate] [smalldatetime] NULL,
	[PlainMessageText] [text] NULL,
	[DateAdded] [smalldatetime] NULL,
	[LabKey] [int] NULL,
 CONSTRAINT [PK_tSystemMessage] PRIMARY KEY CLUSTERED 
(
	[SystemMessageKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
