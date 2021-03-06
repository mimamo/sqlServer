USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tWebDavLog]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tWebDavLog](
	[WebDavLogKey] [uniqueidentifier] NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[ActionDate] [smalldatetime] NULL,
	[Method] [varchar](50) NULL,
	[URL] [varchar](2000) NULL,
	[ResponseCode] [int] NULL,
 CONSTRAINT [PK_tWebDavLog] PRIMARY KEY CLUSTERED 
(
	[WebDavLogKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
