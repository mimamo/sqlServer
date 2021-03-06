USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[UnionDeduct]    Script Date: 12/21/2015 13:56:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UnionDeduct](
	[AllId] [char](4) NOT NULL,
	[BaseId] [char](10) NOT NULL,
	[BaseType] [char](1) NOT NULL,
	[BoxLet] [char](1) NOT NULL,
	[BwkMinAmtPerPd] [float] NOT NULL,
	[CalcMthd] [char](2) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DedId] [char](10) NOT NULL,
	[FxdPctRate] [float] NOT NULL,
	[HeadId] [char](4) NOT NULL,
	[JointId] [char](4) NOT NULL,
	[Labor_Class_Cd] [char](4) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MarriedId] [char](4) NOT NULL,
	[MonMinAmtPerPd] [float] NOT NULL,
	[NoteId] [int] NOT NULL,
	[Override] [smallint] NOT NULL,
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
	[SingleId] [char](4) NOT NULL,
	[SmonMinAmtPerPd] [float] NOT NULL,
	[Union_Cd] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WklyMinAmtPerPd] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [UnionDeduct0] PRIMARY KEY NONCLUSTERED 
(
	[Union_Cd] ASC,
	[Labor_Class_Cd] ASC,
	[DedId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
