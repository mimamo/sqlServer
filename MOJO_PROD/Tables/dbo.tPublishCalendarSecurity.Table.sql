USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tPublishCalendarSecurity]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPublishCalendarSecurity](
	[PublishCalendarKey] [int] NOT NULL,
	[SecurityGroupKey] [int] NOT NULL,
 CONSTRAINT [PK_tPublishCalendarSecurity] PRIMARY KEY CLUSTERED 
(
	[PublishCalendarKey] ASC,
	[SecurityGroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
