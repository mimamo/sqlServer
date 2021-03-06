USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCalendarResource]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCalendarResource](
	[CalendarResourceKey] [int] IDENTITY(1,1) NOT NULL,
	[ResourceName] [varchar](200) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[UserKey] [int] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[CalendarColor] [varchar](50) NULL,
 CONSTRAINT [PK_tCalendarResource] PRIMARY KEY CLUSTERED 
(
	[CalendarResourceKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCalendarResource] ADD  CONSTRAINT [DF_tCalendarResource_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
