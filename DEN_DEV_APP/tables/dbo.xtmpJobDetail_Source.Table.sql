USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[xtmpJobDetail_Source]    Script Date: 12/21/2015 14:05:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xtmpJobDetail_Source](
	[JobNbr] [nvarchar](6) NULL,
	[Client] [nvarchar](18) NULL,
	[Product] [nvarchar](18) NULL,
	[TaskCd] [nvarchar](21) NULL,
	[Estimate] [float] NULL,
	[TranType] [nvarchar](2) NULL,
	[TranDate] [nvarchar](20) NULL,
	[CoVendId] [nvarchar](20) NULL,
	[POInvNbr] [nvarchar](24) NULL,
	[ClientInvoice] [nvarchar](21) NULL,
	[ClientAmt] [float] NULL,
	[Hours] [float] NULL,
	[BilledAmt] [float] NULL,
	[NetAmt] [float] NULL,
	[CommAmt] [float] NULL
) ON [PRIMARY]
GO
