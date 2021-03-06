USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xqAAuditMaster]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xqAAuditMaster](
	[RI_ID] [smallint] NOT NULL,
	[AuditTableName] [varchar](30) NOT NULL,
	[PostAID] [int] NOT NULL,
	[PreAID] [int] NOT NULL,
	[ASLUserID] [varchar](47) NOT NULL,
	[ASQLUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [char](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [xqAAuditMaster0] PRIMARY KEY CLUSTERED 
(
	[AuditTableName] ASC,
	[PostAID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
