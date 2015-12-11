USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTimeSheet]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTimeSheet](
	[TimeSheetKey] [int] IDENTITY(1,1) NOT NULL,
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
 CONSTRAINT [tTimeSheet_PK] PRIMARY KEY CLUSTERED 
(
	[TimeSheetKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tTimeSheet] ADD  CONSTRAINT [DF_tTimeSheet_Status]  DEFAULT ((1)) FOR [Status]
GO
