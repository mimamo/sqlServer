USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tAppCalendar]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tAppCalendar](
	[UserKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Display] [tinyint] NOT NULL,
	[CalendarColor] [varchar](50) NULL,
	[OwnerUserKey] [int] NULL,
	[WhiteText] [tinyint] NOT NULL,
 CONSTRAINT [PK_tAppCalendar] PRIMARY KEY CLUSTERED 
(
	[UserKey] ASC,
	[Entity] ASC,
	[EntityKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tAppCalendar] ADD  CONSTRAINT [DF_tAppCalendar_Selected]  DEFAULT ((0)) FOR [Display]
GO
ALTER TABLE [dbo].[tAppCalendar] ADD  CONSTRAINT [DF_tAppCalendar_WhiteText]  DEFAULT ((0)) FOR [WhiteText]
GO
