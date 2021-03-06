USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[FSTrslHd]    Script Date: 12/21/2015 15:42:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FSTrslHd](
	[AvgRate] [float] NOT NULL,
	[BalShtRate] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[DocDate] [smalldatetime] NOT NULL,
	[DocDesc] [char](30) NOT NULL,
	[DocType] [char](1) NOT NULL,
	[DstBatNbr] [char](10) NOT NULL,
	[DstCrTot] [float] NOT NULL,
	[DstCuryID] [char](4) NOT NULL,
	[DstDrTot] [float] NOT NULL,
	[DstLedgerID] [char](10) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[LineCntr] [int] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[Rlsed] [smallint] NOT NULL,
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
	[SrcBalType] [char](1) NOT NULL,
	[SrcBatFlg] [smallint] NOT NULL,
	[SrcBatNbr] [char](10) NOT NULL,
	[SrcCrTot] [float] NOT NULL,
	[SrcCuryID] [char](4) NOT NULL,
	[SrcDrTot] [float] NOT NULL,
	[SrcLedgerID] [char](10) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TrslId] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [FSTrslHd0] PRIMARY KEY CLUSTERED 
(
	[RefNbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
