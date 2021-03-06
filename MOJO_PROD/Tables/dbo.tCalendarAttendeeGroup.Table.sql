USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCalendarAttendeeGroup]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCalendarAttendeeGroup](
	[CalendarKey] [int] NULL,
	[CalendarAttendeeKey] [int] NOT NULL,
	[DistributionGroupKey] [int] NOT NULL,
 CONSTRAINT [PK_tCalendarAttendeeGroup] PRIMARY KEY CLUSTERED 
(
	[CalendarAttendeeKey] ASC,
	[DistributionGroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tCalendarAttendeeGroup]  WITH CHECK ADD  CONSTRAINT [FK_tCalendarAttendeeGroup_tCalendarAttendee] FOREIGN KEY([CalendarAttendeeKey])
REFERENCES [dbo].[tCalendarAttendee] ([CalendarAttendeeKey])
GO
ALTER TABLE [dbo].[tCalendarAttendeeGroup] CHECK CONSTRAINT [FK_tCalendarAttendeeGroup_tCalendarAttendee]
GO
ALTER TABLE [dbo].[tCalendarAttendeeGroup]  WITH CHECK ADD  CONSTRAINT [FK_tCalendarAttendeeGroup_tDistributionGroup] FOREIGN KEY([DistributionGroupKey])
REFERENCES [dbo].[tDistributionGroup] ([DistributionGroupKey])
GO
ALTER TABLE [dbo].[tCalendarAttendeeGroup] CHECK CONSTRAINT [FK_tCalendarAttendeeGroup_tDistributionGroup]
GO
