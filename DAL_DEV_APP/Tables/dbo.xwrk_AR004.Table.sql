USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[xwrk_AR004]    Script Date: 12/21/2015 13:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_AR004](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [varchar](50) NOT NULL,
	[RunDate] [smalldatetime] NOT NULL,
	[RunTime] [varchar](50) NOT NULL,
	[TerminalNum] [varchar](50) NOT NULL,
	[CustID] [varchar](50) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[ClientRefNum] [varchar](50) NULL,
	[JobDescr] [varchar](50) NULL,
	[ProdCode] [varchar](50) NULL,
	[RefNbr] [varchar](50) NOT NULL,
	[DueDate] [smalldatetime] NOT NULL,
	[DocDate] [smalldatetime] NOT NULL,
	[DocType] [char](2) NOT NULL,
	[CuryOrigDocAmt] [float] NOT NULL,
	[CuryDocBal] [float] NOT NULL,
	[AvgDayToPay] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[TotalAdjdAmt] [float] NOT NULL,
	[AdjdRefNbr] [varchar](50) NOT NULL,
	[AdjgDocType] [char](2) NOT NULL,
	[RecordID] [int] NOT NULL,
	[DateAppl] [smalldatetime] NOT NULL,
	[ClassID] [varchar](25) NULL,
	[CurrentAmt] [float] NOT NULL,
	[Past1] [float] NOT NULL,
	[Past2] [float] NOT NULL,
	[Past3] [float] NOT NULL,
	[Past4] [float] NOT NULL,
	[Past5] [float] NOT NULL,
	[Over180] [float] NOT NULL,
	[Total] [float] NOT NULL,
	[DateDiffDocDate] [int] NULL,
	[DateDiffDueDate] [int] NULL,
	[BatNbr] [char](10) NOT NULL,
	[BatSeq] [int] NOT NULL,
 CONSTRAINT [PK_xwrk_AR004] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
