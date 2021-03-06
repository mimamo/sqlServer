USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xwrk_CoorsInvoice]    Script Date: 12/21/2015 15:54:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_CoorsInvoice](
	[RI_ID] [int] NOT NULL,
	[UserID] [varchar](50) NOT NULL,
	[RunDate] [smalldatetime] NOT NULL,
	[RunTime] [varchar](10) NOT NULL,
	[TerminalNum] [varchar](50) NOT NULL,
	[InvoiceNum] [char](10) NOT NULL,
	[DraftNum] [char](10) NOT NULL,
	[Invoice_Date] [smalldatetime] NOT NULL,
	[InvoiceStatus] [char](2) NOT NULL,
	[InvoiceAmount] [float] NOT NULL,
	[InvoiceItemDescription] [varchar](max) NOT NULL,
	[Function] [varchar](50) NOT NULL,
	[Project] [char](16) NOT NULL,
	[ProjectDescription] [varchar](150) NOT NULL,
	[SourceTrxID] [int] NOT NULL,
	[CustCode] [varchar](50) NOT NULL,
	[InvoiceType] [char](4) NOT NULL,
	[OrigInvoiceNum] [char](30) NOT NULL,
	[PONum] [char](20) NOT NULL,
	[ProductCode] [char](30) NOT NULL,
	[Product] [char](30) NOT NULL,
	[CustName] [char](30) NOT NULL,
	[BeginDate] [smalldatetime] NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[ArchiveTableDup] [int] NOT NULL,
	[Action] [varchar](50) NOT NULL,
 CONSTRAINT [PK_xwrk_CoorsInvoice] PRIMARY KEY CLUSTERED 
(
	[RI_ID] ASC,
	[InvoiceNum] ASC,
	[SourceTrxID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
