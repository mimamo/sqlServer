USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xtmpProjectDetail_vendInvc]    Script Date: 12/21/2015 13:56:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpProjectDetail_vendInvc](
	[detail_num] [int] NOT NULL,
	[origRecID] [int] NULL,
	[acct] [varchar](255) NULL,
	[JobNbr] [varchar](255) NULL,
	[TaskCd] [varchar](255) NULL,
	[Client] [varchar](255) NULL,
	[Product] [varchar](255) NULL,
	[Estimate] [float] NULL,
	[TranType] [varchar](255) NULL,
	[TranDate] [varchar](255) NULL,
	[CoVendId] [varchar](255) NULL,
	[DSLVendID] [varchar](255) NULL,
	[POInvNbr] [varchar](255) NULL,
	[TranDesc] [varchar](255) NULL,
	[ClientInvoice] [varchar](255) NULL,
	[ClientAmt] [float] NULL,
	[Hours] [float] NULL,
	[BilledAmt] [float] NULL,
	[NetAmt] [float] NULL,
	[CommAmt] [float] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
