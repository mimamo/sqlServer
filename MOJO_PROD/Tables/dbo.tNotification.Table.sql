USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tNotification]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tNotification](
	[NotificationID] [varchar](20) NOT NULL,
	[NotificationName] [varchar](200) NULL,
	[DisplayGroup] [int] NULL,
	[DisplayOrder] [int] NULL,
	[Description] [varchar](1000) NULL,
	[ValueType] [smallint] NULL,
	[ValueLabel] [varchar](200) NULL,
	[ValueDropDown] [varchar](1000) NULL,
	[ValueDropDown2] [varchar](1000) NULL,
 CONSTRAINT [PK_tNotification] PRIMARY KEY NONCLUSTERED 
(
	[NotificationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
