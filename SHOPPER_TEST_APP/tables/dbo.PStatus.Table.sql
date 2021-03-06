USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[PStatus]    Script Date: 12/21/2015 16:06:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PStatus](
	[ExecDate] [smalldatetime] NOT NULL,
	[ExecTime] [smalldatetime] NOT NULL,
	[InternetAddress] [char](21) NOT NULL,
	[PID] [char](10) NOT NULL,
	[ProcTime] [int] NOT NULL,
	[RecordID] [int] IDENTITY(1,1) NOT NULL,
	[SessionCntr] [smallint] NOT NULL,
	[Status] [char](1) NOT NULL,
	[UserId] [char](47) NOT NULL,
	[ViewDate] [smalldatetime] NOT NULL,
	[zfilename] [char](254) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PStatus0] PRIMARY KEY CLUSTERED 
(
	[PID] ASC,
	[UserId] ASC,
	[InternetAddress] ASC,
	[SessionCntr] ASC,
	[ExecDate] ASC,
	[ExecTime] ASC,
	[Status] ASC,
	[RecordID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
