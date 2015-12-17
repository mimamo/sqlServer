USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tUserNotification]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tUserNotification](
	[UserKey] [int] NOT NULL,
	[NotificationID] [varchar](20) NOT NULL,
	[Value] [int] NULL,
	[Value2] [int] NULL,
 CONSTRAINT [PK_tUserNotification] PRIMARY KEY NONCLUSTERED 
(
	[UserKey] ASC,
	[NotificationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
