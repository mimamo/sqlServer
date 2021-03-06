USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tActivity]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tActivity](
	[ActivityKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ParentActivityKey] [int] NOT NULL,
	[RootActivityKey] [int] NOT NULL,
	[Private] [tinyint] NULL,
	[Type] [varchar](50) NULL,
	[Priority] [varchar](20) NULL,
	[Subject] [varchar](2000) NULL,
	[ContactCompanyKey] [int] NULL,
	[ContactKey] [int] NULL,
	[UserLeadKey] [int] NULL,
	[LeadKey] [int] NULL,
	[ProjectKey] [int] NULL,
	[StandardActivityKey] [int] NULL,
	[AssignedUserKey] [int] NULL,
	[OriginatorUserKey] [int] NULL,
	[Outcome] [smallint] NULL,
	[ActivityDate] [smalldatetime] NULL,
	[StartTime] [smalldatetime] NULL,
	[EndTime] [smalldatetime] NULL,
	[ReminderMinutes] [int] NULL,
	[ActivityTime] [varchar](50) NULL,
	[Completed] [tinyint] NULL,
	[DateCompleted] [smalldatetime] NULL,
	[Notes] [text] NULL,
	[DateAdded] [smalldatetime] NULL,
	[DateUpdated] [datetime] NULL,
	[CustomFieldKey] [int] NULL,
	[AddedByKey] [int] NULL,
	[UpdatedByKey] [int] NULL,
	[VisibleToClient] [tinyint] NULL,
	[OldNoteKey] [int] NULL,
	[OldParentNoteKey] [int] NULL,
	[CMFolderKey] [int] NULL,
	[TaskKey] [int] NULL,
	[ActivityTypeKey] [int] NULL,
	[SubjectIndex] [varchar](100) NULL,
	[UID] [varchar](2000) NOT NULL,
	[Sequence] [int] NULL,
	[ActivityEntity] [varchar](50) NULL,
	[DisplayOrder] [int] NULL,
	[GLCompanyKey] [int] NULL,
	[CompletedByKey] [int] NULL,
	[ActivityStatusKey] [int] NULL,
 CONSTRAINT [PK_tActivity] PRIMARY KEY CLUSTERED 
(
	[ActivityKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tActivity] ADD  CONSTRAINT [DF_tActivity_ParentActivityKey]  DEFAULT ((0)) FOR [ParentActivityKey]
GO
ALTER TABLE [dbo].[tActivity] ADD  CONSTRAINT [DF_tActivity_RootActivityKey]  DEFAULT ((0)) FOR [RootActivityKey]
GO
ALTER TABLE [dbo].[tActivity] ADD  CONSTRAINT [DF_tActivity_Priority]  DEFAULT ('2-Medium') FOR [Priority]
GO
ALTER TABLE [dbo].[tActivity] ADD  CONSTRAINT [DF_tActivity_Completed]  DEFAULT ((0)) FOR [Completed]
GO
ALTER TABLE [dbo].[tActivity] ADD  CONSTRAINT [DF_tActivity_DateAdded]  DEFAULT (getutcdate()) FOR [DateAdded]
GO
ALTER TABLE [dbo].[tActivity] ADD  CONSTRAINT [DF_tActivity_DateUpdated]  DEFAULT (getutcdate()) FOR [DateUpdated]
GO
ALTER TABLE [dbo].[tActivity] ADD  CONSTRAINT [DF_tActivity_UID]  DEFAULT (newid()) FOR [UID]
GO
