USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDBLog]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tDBLog](
	[DBLogKey] [int] IDENTITY(1,1) NOT NULL,
	[TranTime] [smalldatetime] NOT NULL,
	[CompleteTime] [smalldatetime] NULL,
	[UserKey] [int] NOT NULL,
	[Method] [varchar](50) NULL,
	[Parameters] [text] NULL,
 CONSTRAINT [PK_tDBLog] PRIMARY KEY CLUSTERED 
(
	[DBLogKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tDBLog] ADD  CONSTRAINT [DF_tDBLog_TranTime]  DEFAULT (getdate()) FOR [TranTime]
GO
