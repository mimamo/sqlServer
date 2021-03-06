USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[xtmpProjectDetail_ADD3a]    Script Date: 12/21/2015 14:05:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpProjectDetail_ADD3a](
	[detail_num] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
	[CommAmt] [float] NULL,
 CONSTRAINT [PK_xtmpProjectDetailADD3a] PRIMARY KEY CLUSTERED 
(
	[detail_num] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
