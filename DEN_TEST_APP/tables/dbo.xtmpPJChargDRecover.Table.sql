USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xtmpPJChargDRecover]    Script Date: 12/21/2015 14:10:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpPJChargDRecover](
	[origDetailNum] [int] NOT NULL,
	[origRecID] [int] NOT NULL,
	[invYN] [varchar](255) NOT NULL,
	[detail_num] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[acct] [varchar](255) NULL,
	[fiscalNo] [varchar](255) NULL,
	[billableflag] [varchar](255) NULL,
	[Project] [varchar](255) NULL,
	[JobNbr] [varchar](255) NULL,
	[tranType] [varchar](255) NULL,
	[TaskCd] [varchar](255) NULL,
	[Client] [varchar](255) NULL,
	[Product] [varchar](255) NULL,
	[TranDate] [varchar](255) NULL,
	[CoVendId] [varchar](255) NULL,
	[DSLVendId] [varchar](255) NULL,
	[POInvNbr] [varchar](255) NULL,
	[TranDesc] [varchar](255) NULL,
	[ClientInvoice] [varchar](255) NULL,
	[amount] [float] NULL,
 CONSTRAINT [PK_xxtmpPJChargDRecover] PRIMARY KEY CLUSTERED 
(
	[detail_num] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
