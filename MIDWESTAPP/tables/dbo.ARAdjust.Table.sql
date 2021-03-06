USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[ARAdjust]    Script Date: 12/21/2015 15:54:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ARAdjust](
	[AdjAmt] [float] NOT NULL,
	[AdjBatNbr] [char](10) NOT NULL,
	[AdjdDocType] [char](2) NOT NULL,
	[AdjDiscAmt] [float] NOT NULL,
	[AdjdRefNbr] [char](10) NOT NULL,
	[AdjgDocDate] [smalldatetime] NOT NULL,
	[AdjgDocType] [char](2) NOT NULL,
	[AdjgPerPost] [char](6) NOT NULL,
	[AdjgRefNbr] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryAdjdAmt] [float] NOT NULL,
	[CuryAdjdCuryId] [char](4) NOT NULL,
	[CuryAdjdDiscAmt] [float] NOT NULL,
	[CuryAdjdMultDiv] [char](1) NOT NULL,
	[CuryAdjdRate] [float] NOT NULL,
	[CuryAdjgAmt] [float] NOT NULL,
	[CuryAdjgDiscAmt] [float] NOT NULL,
	[CuryRGOLAmt] [float] NOT NULL,
	[CustId] [char](15) NOT NULL,
	[DateAppl] [smalldatetime] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PC_Status] [char](1) NOT NULL,
	[PerAppl] [char](6) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[RecordID] [int] IDENTITY(1,1) NOT NULL,
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
	[TaskID] [char](32) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [ARAdjust0] PRIMARY KEY CLUSTERED 
(
	[AdjdRefNbr] ASC,
	[RecordID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
