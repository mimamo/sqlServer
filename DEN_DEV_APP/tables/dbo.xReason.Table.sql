USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[xReason]    Script Date: 12/21/2015 14:05:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xReason](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ItemID] [varchar](50) NOT NULL,
	[ReasonID] [int] NOT NULL,
	[Reason_descr] [varchar](max) NOT NULL,
	[Status] [char](2) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_user] [varchar](50) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_user] [varchar](50) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [idx_reason0] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
