USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[vs_AcctXref]    Script Date: 12/21/2015 14:26:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[vs_AcctXref](
	[Acct] [char](10) NOT NULL,
	[AcctType] [char](2) NULL,
	[Active] [smallint] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Descr] [char](30) NULL,
	[User1] [char](30) NULL,
	[User2] [char](30) NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [vs_AcctXRef0] PRIMARY KEY CLUSTERED 
(
	[CpnyID] ASC,
	[Acct] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
