USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tContactActivity]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tContactActivity](
	[ContactActivityKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Type] [varchar](50) NULL,
	[Priority] [varchar](20) NULL,
	[Subject] [varchar](2000) NOT NULL,
	[ContactCompanyKey] [int] NULL,
	[ContactKey] [int] NULL,
	[AssignedUserKey] [int] NOT NULL,
	[Status] [smallint] NOT NULL,
	[Outcome] [smallint] NULL,
	[ActivityDate] [smalldatetime] NULL,
	[ActivityTime] [varchar](50) NULL,
	[DateCompleted] [smalldatetime] NULL,
	[LeadKey] [int] NULL,
	[ProjectKey] [int] NULL,
	[Notes] [text] NULL,
	[DateAdded] [smalldatetime] NULL,
	[DateUpdated] [smalldatetime] NULL,
	[ParentActivityKey] [int] NOT NULL,
	[RootActivityKey] [int] NOT NULL,
	[UserLeadKey] [int] NULL,
	[OriginatorUserKey] [int] NULL,
	[StartTime] [smalldatetime] NULL,
	[EndTime] [smalldatetime] NULL,
	[ReminderMinutes] [int] NULL,
	[Completed] [tinyint] NULL,
 CONSTRAINT [PK_tContactActivity] PRIMARY KEY NONCLUSTERED 
(
	[ContactActivityKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tContactActivity] ADD  CONSTRAINT [DF_tContactActivity_Priority]  DEFAULT ('2-Medium') FOR [Priority]
GO
ALTER TABLE [dbo].[tContactActivity] ADD  CONSTRAINT [DF_tContactActivity_Status]  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[tContactActivity] ADD  CONSTRAINT [DF_tContactActivity_DateAdded]  DEFAULT (getdate()) FOR [DateAdded]
GO
ALTER TABLE [dbo].[tContactActivity] ADD  CONSTRAINT [DF_tContactActivity_DateUpdated]  DEFAULT (getdate()) FOR [DateUpdated]
GO
ALTER TABLE [dbo].[tContactActivity] ADD  CONSTRAINT [DF_tContactActivity_ParentActivityKey]  DEFAULT ((0)) FOR [ParentActivityKey]
GO
ALTER TABLE [dbo].[tContactActivity] ADD  CONSTRAINT [DF_tContactActivity_RootActivityKey]  DEFAULT ((0)) FOR [RootActivityKey]
GO
ALTER TABLE [dbo].[tContactActivity] ADD  CONSTRAINT [DF_tContactActivity_Completed]  DEFAULT ((0)) FOR [Completed]
GO
