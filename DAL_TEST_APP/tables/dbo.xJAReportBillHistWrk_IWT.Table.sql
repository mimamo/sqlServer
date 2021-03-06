USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xJAReportBillHistWrk_IWT]    Script Date: 12/21/2015 13:56:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xJAReportBillHistWrk_IWT](
	[SessionGUID] [varchar](255) NOT NULL,
	[Project] [varchar](16) NULL,
	[Amount] [decimal](15, 3) NULL,
	[CheckNumber] [varchar](10) NULL,
	[DocDate] [smalldatetime] NULL,
	[DocType] [varchar](2) NULL,
	[InvoiceNbr] [varchar](10) NULL,
	[Payment] [decimal](15, 3) NULL,
	[Source] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
