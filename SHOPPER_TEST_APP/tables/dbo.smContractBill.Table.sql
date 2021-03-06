USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[smContractBill]    Script Date: 12/21/2015 16:06:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smContractBill](
	[AmtPaid] [float] NOT NULL,
	[ARBatNbr] [char](10) NOT NULL,
	[ARRefNbr] [char](10) NOT NULL,
	[BillAmount] [float] NOT NULL,
	[BillDate] [smalldatetime] NOT NULL,
	[BillFlag] [smallint] NOT NULL,
	[CB_D04] [char](20) NOT NULL,
	[CB_ID01] [char](30) NOT NULL,
	[CB_ID02] [char](30) NOT NULL,
	[CB_ID03] [char](20) NOT NULL,
	[CB_ID05] [char](10) NOT NULL,
	[CB_ID06] [char](10) NOT NULL,
	[CB_ID07] [char](4) NOT NULL,
	[CB_ID08] [float] NOT NULL,
	[CB_ID09] [smalldatetime] NOT NULL,
	[CB_ID10] [smallint] NOT NULL,
	[CmmnAmt] [float] NOT NULL,
	[Comment] [char](30) NOT NULL,
	[CmmnPct] [float] NOT NULL,
	[CmmnStatus] [smallint] NOT NULL,
	[ContractID] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DocType] [char](2) NOT NULL,
	[InvBatNbr] [char](10) NOT NULL,
	[InvoiceLineID] [smallint] NOT NULL,
	[InvoiceNbr] [char](10) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MiscAmt] [float] NOT NULL,
	[NbrOfCalls] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[ProcessDate] [smalldatetime] NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaskID] [char](32) NOT NULL,
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
