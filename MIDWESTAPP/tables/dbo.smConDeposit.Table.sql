USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[smConDeposit]    Script Date: 12/21/2015 15:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smConDeposit](
	[AccruedtoGl] [smallint] NOT NULL,
	[Acct] [char](10) NOT NULL,
	[Amount] [float] NOT NULL,
	[AmtApplied] [float] NOT NULL,
	[ARBatNbr] [char](10) NOT NULL,
	[ARRefNbr] [char](10) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BillDate] [smalldatetime] NOT NULL,
	[BranchID] [char](10) NOT NULL,
	[Contractid] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[GLBatNbr] [char](10) NOT NULL,
	[InvBatNbr] [char](10) NOT NULL,
	[InvoiceLineID] [smallint] NOT NULL,
	[InvoiceNbr] [char](10) NOT NULL,
	[InvtId] [char](30) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrdNbr] [char](10) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[ProcessDate] [smalldatetime] NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[Rebill] [smallint] NOT NULL,
	[RebillDate] [smalldatetime] NOT NULL,
	[Refnbr] [char](10) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[Status] [char](1) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
