USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xtmpProjectDetail_PreBill_Source]    Script Date: 12/21/2015 13:56:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpProjectDetail_PreBill_Source](
	[Client] [varchar](50) NULL,
	[productcode] [varchar](50) NULL,
	[jobcode] [varchar](50) NULL,
	[jobdesc] [varchar](50) NULL,
	[dslJob] [varchar](50) NULL,
	[prebillInvoice] [varchar](50) NULL,
	[Date] [varchar](50) NULL,
	[prebillAmt] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
