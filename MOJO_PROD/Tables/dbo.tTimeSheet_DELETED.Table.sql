USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTimeSheet_DELETED]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTimeSheet_DELETED](
	[TimeSheet_DELETED_Key] [int] IDENTITY(1,1) NOT NULL,
	[TimeSheetKey] [int] NOT NULL,
	[CompanyKey] [int] NULL,
	[UserKey] [int] NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[Status] [smallint] NOT NULL,
	[ApprovalComments] [varchar](300) NULL,
	[DateCreated] [smalldatetime] NULL,
	[DateSubmitted] [smalldatetime] NULL,
	[DateApproved] [smalldatetime] NULL,
	[ApprovedByKey] [int] NULL,
 CONSTRAINT [PK_tTimeSheet_DELETED] PRIMARY KEY CLUSTERED 
(
	[TimeSheet_DELETED_Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tTimeSheet_DELETED] ADD  CONSTRAINT [DF_tTimeSheet_DELETED_Status]  DEFAULT ((1)) FOR [Status]
GO
