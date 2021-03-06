USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[Record]    Script Date: 12/21/2015 16:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Record](
	[Active] [char](1) NOT NULL,
	[DATFileName] [char](8) NOT NULL,
	[Module] [char](2) NOT NULL,
	[OldRecordName] [char](20) NOT NULL,
	[RecordDescripti] [char](25) NOT NULL,
	[RecordName] [char](20) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [Record0] PRIMARY KEY CLUSTERED 
(
	[RecordName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
