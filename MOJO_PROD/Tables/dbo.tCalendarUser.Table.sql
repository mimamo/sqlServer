USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCalendarUser]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCalendarUser](
	[UserKey] [int] NOT NULL,
	[CalendarUserKey] [int] NOT NULL,
	[AccessType] [smallint] NOT NULL,
	[SendEmail] [tinyint] NULL,
 CONSTRAINT [PK_tCalendarUser] PRIMARY KEY NONCLUSTERED 
(
	[UserKey] ASC,
	[CalendarUserKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
