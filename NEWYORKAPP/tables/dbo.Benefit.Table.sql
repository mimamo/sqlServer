USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[Benefit]    Script Date: 12/21/2015 16:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Benefit](
	[AccrLiab] [smallint] NOT NULL,
	[AccrMthd] [char](1) NOT NULL,
	[AvailMthd] [char](1) NOT NULL,
	[BenId] [char](10) NOT NULL,
	[ClassId] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[ExpAcct] [char](10) NOT NULL,
	[ExpDate] [smalldatetime] NOT NULL,
	[ExpSub] [char](24) NOT NULL,
	[LiabAcct] [char](10) NOT NULL,
	[LiabSub] [char](24) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[PlanYrBegin] [char](4) NOT NULL,
	[PrtOnStub] [smallint] NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[TrnsBenId] [char](10) NOT NULL,
	[TrnsCarryFwdHist] [smallint] NOT NULL,
	[TrnsDate] [smalldatetime] NOT NULL,
	[TrnsMthd] [char](1) NOT NULL,
	[TrnsUnits] [smallint] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[YearType] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [Benefit0] PRIMARY KEY CLUSTERED 
(
	[BenId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
