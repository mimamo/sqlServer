USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[xClientContact]    Script Date: 12/21/2015 14:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xClientContact](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EA_ID] [char](10) NULL,
	[EmailAddress] [char](50) NOT NULL,
	[CName] [char](30) NOT NULL,
	[Status] [char](1) NOT NULL,
	[Company] [char](30) NULL,
	[crtd_user] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](10) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_xClientContact] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
