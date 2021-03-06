USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[Wrk_APTran]    Script Date: 12/21/2015 14:05:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wrk_APTran](
	[Acct] [char](10) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryTranAmt] [float] NOT NULL,
	[DrCr] [char](1) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[InstallNbr] [smallint] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MasterDocNbr] [char](10) NOT NULL,
	[PerEnt] [char](6) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[PmtMethod] [char](1) NOT NULL,
	[RecordID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[TranAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDesc] [char](30) NOT NULL,
	[trantype] [char](2) NOT NULL,
	[VendId] [char](15) NOT NULL,
	[UserAddress] [char](21) NOT NULL,
 CONSTRAINT [Wrk_APTran0] PRIMARY KEY NONCLUSTERED 
(
	[RecordID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
