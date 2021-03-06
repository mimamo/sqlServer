USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[CalcChkDet]    Script Date: 12/21/2015 13:56:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CalcChkDet](
	[ArrgCurr] [float] NOT NULL,
	[ArrgYTD] [float] NOT NULL,
	[CalYTDEarnDed] [float] NOT NULL,
	[ChkSeq] [char](2) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrEarnDedAmt] [float] NOT NULL,
	[CurrRptEarnSubjDed] [float] NOT NULL,
	[CurrUnits] [float] NOT NULL,
	[EarnDedId] [char](10) NOT NULL,
	[EDType] [char](1) NOT NULL,
	[EmpID] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
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
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WrkLocId] [char](6) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [CalcChkDet0] PRIMARY KEY CLUSTERED 
(
	[EmpID] ASC,
	[ChkSeq] ASC,
	[EDType] ASC,
	[WrkLocId] ASC,
	[EarnDedId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
