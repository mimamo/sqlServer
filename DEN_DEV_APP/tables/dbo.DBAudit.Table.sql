USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[DBAudit]    Script Date: 12/21/2015 14:05:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DBAudit](
	[RecordID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RecordOwner] [varchar](30) NOT NULL,
	[RecordDate] [datetime] NOT NULL,
	[RecordUser] [varchar](30) NOT NULL,
	[RecordText] [varchar](255) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
