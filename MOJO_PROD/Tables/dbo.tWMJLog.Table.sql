USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tWMJLog]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tWMJLog](
	[WMJLogKey] [int] IDENTITY(1,1) NOT NULL,
	[ActionDate] [smalldatetime] NOT NULL,
	[CompanyKey] [int] NULL,
	[UserKey] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[Message] [varchar](500) NULL,
	[Method] [varchar](100) NULL,
	[CallingApplicationID] [varchar](100) NULL,
	[CallStack] [varchar](8000) NULL,
 CONSTRAINT [PK_tWMJLog] PRIMARY KEY CLUSTERED 
(
	[WMJLogKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tWMJLog] ADD  CONSTRAINT [DF_tWMJLog_ActionDate]  DEFAULT (getutcdate()) FOR [ActionDate]
GO
