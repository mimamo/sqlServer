USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMessage]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMessage](
	[MessageKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Subject] [varchar](500) NULL,
	[Message] [text] NULL,
	[Priority] [smallint] NULL,
	[DateAdded] [smalldatetime] NULL,
	[AddedByKey] [int] NULL,
	[MessageType] [varchar](50) NULL,
 CONSTRAINT [PK_tMessage] PRIMARY KEY CLUSTERED 
(
	[MessageKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
