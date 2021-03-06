USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tRequest]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tRequest](
	[RequestKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[RequestDefKey] [int] NOT NULL,
	[CustomFieldKey] [int] NOT NULL,
	[RequestID] [varchar](50) NULL,
	[Status] [smallint] NOT NULL,
	[DateAdded] [smalldatetime] NULL,
	[DateCompleted] [smalldatetime] NULL,
	[EnteredByKey] [int] NULL,
	[RequestedBy] [varchar](150) NULL,
	[NotifyEmail] [varchar](100) NULL,
	[Subject] [varchar](100) NULL,
	[ClientProjectNumber] [varchar](200) NULL,
	[ProjectDescription] [text] NULL,
	[DueDate] [smalldatetime] NULL,
	[CampaignID] [varchar](50) NULL,
	[Cancelled] [smallint] NOT NULL,
	[DateSentForApproval] [smalldatetime] NULL,
	[DateCancelled] [smalldatetime] NULL,
	[UpdatedByKey] [int] NULL,
	[DateUpdated] [datetime] NULL,
	[RequestRejectReasonKey] [int] NULL,
 CONSTRAINT [PK_tRequest] PRIMARY KEY CLUSTERED 
(
	[RequestKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tRequest]  WITH NOCHECK ADD  CONSTRAINT [FK_tRequest_tRequestDef] FOREIGN KEY([RequestDefKey])
REFERENCES [dbo].[tRequestDef] ([RequestDefKey])
GO
ALTER TABLE [dbo].[tRequest] CHECK CONSTRAINT [FK_tRequest_tRequestDef]
GO
ALTER TABLE [dbo].[tRequest] ADD  CONSTRAINT [DF_tRequest_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[tRequest] ADD  CONSTRAINT [DF_tRequest_Cancelled]  DEFAULT ((0)) FOR [Cancelled]
GO
