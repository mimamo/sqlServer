USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTaskAssignmentType]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTaskAssignmentType](
	[TaskAssignmentTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[TaskAssignmentType] [varchar](200) NOT NULL,
	[CalendarColor] [varchar](20) NULL,
	[Active] [tinyint] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tTaskAssignmentType] PRIMARY KEY CLUSTERED 
(
	[TaskAssignmentTypeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tTaskAssignmentType] ADD  CONSTRAINT [DF__tTaskAssi__LastM__5C1ADE78]  DEFAULT (getutcdate()) FOR [LastModified]
GO
