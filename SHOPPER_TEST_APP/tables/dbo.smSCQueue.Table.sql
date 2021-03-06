USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[smSCQueue]    Script Date: 12/21/2015 16:06:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smSCQueue](
	[CallStatusID] [char](10) NOT NULL,
	[CallTypeID] [char](10) NOT NULL,
	[Comments] [char](60) NOT NULL,
	[CompletedDate] [smalldatetime] NOT NULL,
	[CompletedTime] [char](4) NOT NULL,
	[CompletedUserID] [char](47) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustomerId] [char](15) NOT NULL,
	[DateCalled] [smalldatetime] NOT NULL,
	[DateSchedule] [smalldatetime] NOT NULL,
	[EmployeeID] [char](10) NOT NULL,
	[GeographicID] [char](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[PriorityHigh] [smallint] NOT NULL,
	[PriorityLow] [smallint] NOT NULL,
	[PriorityMedium] [smallint] NOT NULL,
	[ServCallCompleted] [smallint] NOT NULL,
	[ServiceCallID] [char](10) NOT NULL,
	[ShiptoId] [char](10) NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[StartTime] [char](4) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
