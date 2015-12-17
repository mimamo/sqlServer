USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tPublishCalendar]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tPublishCalendar](
	[PublishCalendarKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[PublishCalendarName] [varchar](500) NOT NULL,
	[Criteria] [text] NULL,
 CONSTRAINT [PK_tPublishCalendar] PRIMARY KEY CLUSTERED 
(
	[PublishCalendarKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
