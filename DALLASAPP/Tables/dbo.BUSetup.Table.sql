USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[BUSetup]    Script Date: 12/21/2015 13:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BUSetup](
	[AllowMasking] [smallint] NOT NULL,
	[BudgetLedgerID] [char](10) NOT NULL,
	[BudgetYear] [char](4) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CreateSubAccts] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[Include13] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NumberSegments] [smallint] NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [char](10) NOT NULL,
	[S4Future04] [char](10) NOT NULL,
	[S4Future05] [smallint] NOT NULL,
	[S4Future06] [smallint] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [char](1) NOT NULL,
	[S4Future10] [char](1) NOT NULL,
	[SubSeg00] [smallint] NOT NULL,
	[SubSeg01] [smallint] NOT NULL,
	[SubSeg02] [smallint] NOT NULL,
	[SubSeg03] [smallint] NOT NULL,
	[SubSeg04] [smallint] NOT NULL,
	[SubSeg05] [smallint] NOT NULL,
	[SubSeg06] [smallint] NOT NULL,
	[SubSeg07] [smallint] NOT NULL,
	[SubSegMask00] [char](24) NOT NULL,
	[SubSegMask01] [char](24) NOT NULL,
	[SubSegMask02] [char](24) NOT NULL,
	[SubSegMask03] [char](24) NOT NULL,
	[SubSegMask04] [char](24) NOT NULL,
	[SubSegMask05] [char](24) NOT NULL,
	[SubSegMask06] [char](24) NOT NULL,
	[SubSegMask07] [char](24) NOT NULL,
	[Type] [char](1) NOT NULL,
	[UseBdgtGroups] [smallint] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smallint] NOT NULL,
	[User8] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [BUSetup0] PRIMARY KEY NONCLUSTERED 
(
	[CpnyID] ASC,
	[BudgetLedgerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
