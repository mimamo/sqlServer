USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEmailSendLog]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tEmailSendLog](
	[EmailSendLogKey] [int] IDENTITY(1,1) NOT NULL,
	[EmailSendLogID] [varchar](20) NOT NULL,
	[ActionDate] [smalldatetime] NOT NULL,
	[CompanyKey] [int] NULL,
	[UserKey] [int] NOT NULL,
	[EmailFromAddress] [varchar](254) NULL,
	[EmailToAddress] [varchar](254) NULL,
	[Subject] [varchar](300) NULL,
	[Body] [varchar](8000) NULL,
	[CallingApplicationID] [varchar](100) NULL,
	[Message] [varchar](500) NULL,
 CONSTRAINT [PK_tEmailSendLog] PRIMARY KEY CLUSTERED 
(
	[EmailSendLogKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tEmailSendLog] ADD  CONSTRAINT [DF_tEmailSendLog_ActionDate]  DEFAULT (getutcdate()) FOR [ActionDate]
GO
