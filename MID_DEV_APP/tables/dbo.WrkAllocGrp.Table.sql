USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[WrkAllocGrp]    Script Date: 12/21/2015 14:16:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkAllocGrp](
	[Acct] [char](10) NOT NULL,
	[CBAcct] [char](10) NOT NULL,
	[CBCpnyID] [char](10) NOT NULL,
	[CBSub] [char](24) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[GrpId] [char](6) NOT NULL,
	[LDLSType] [char](1) NOT NULL,
	[LmtDestFact] [float] NOT NULL,
	[RI_ID] [int] NOT NULL,
	[Sub] [char](24) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [WrkAllocGrp0] PRIMARY KEY CLUSTERED 
(
	[GrpId] ASC,
	[LDLSType] ASC,
	[CpnyID] ASC,
	[Acct] ASC,
	[Sub] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
