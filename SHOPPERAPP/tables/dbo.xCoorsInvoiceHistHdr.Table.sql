USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xCoorsInvoiceHistHdr]    Script Date: 12/21/2015 16:12:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xCoorsInvoiceHistHdr](
	[RI_ID] [int] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[RunDate] [datetime] NOT NULL,
	[RunTime] [char](7) NOT NULL,
	[TerminalNum] [char](21) NOT NULL,
	[Batch] [varchar](50) NOT NULL,
	[File] [varchar](150) NOT NULL,
	[BatchTotal] [float] NOT NULL,
	[InvoiceCount] [int] NOT NULL,
	[RowCount] [int] NOT NULL,
	[BeginDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[xmlFile] [xml] NOT NULL,
	[xmlBatchTotal] [float] NOT NULL,
	[xmlInvoiceCount] [int] NOT NULL,
 CONSTRAINT [PK_xCoorsInvoiceHistHdr] PRIMARY KEY CLUSTERED 
(
	[Batch] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
