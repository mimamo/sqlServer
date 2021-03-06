USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[smcondepapplied]    Script Date: 12/21/2015 15:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smcondepapplied](
	[AmtApplied] [float] NOT NULL,
	[ARBatch] [varchar](10) NOT NULL,
	[BatNbr] [varchar](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [varchar](8) NOT NULL,
	[Crtd_User] [varchar](10) NOT NULL,
	[InvoiceDate] [smalldatetime] NOT NULL,
	[InvoiceNbr] [varchar](10) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [varchar](8) NOT NULL,
	[Lupd_User] [varchar](10) NOT NULL,
	[RecordID] [int] IDENTITY(1,1) NOT NULL,
	[S4Future01] [varchar](30) NOT NULL,
	[S4Future02] [varchar](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [varchar](10) NOT NULL,
	[S4Future12] [varchar](10) NOT NULL,
	[User1] [varchar](30) NOT NULL,
	[User2] [varchar](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [varchar](10) NOT NULL,
	[User6] [varchar](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
