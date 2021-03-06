USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xtmpProjectDetail_PreBill]    Script Date: 12/21/2015 15:42:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpProjectDetail_PreBill](
	[detail_num] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[JobNbr] [varchar](255) NULL,
	[TaskCd] [varchar](255) NULL,
	[Client] [varchar](255) NULL,
	[Product] [varchar](255) NULL,
	[TranDate] [varchar](255) NULL,
	[DSLJob] [varchar](255) NULL,
	[ClientInvoice] [varchar](255) NULL,
	[BilledAmt] [float] NULL,
 CONSTRAINT [xtmpProjectDetail_PreBillx] PRIMARY KEY CLUSTERED 
(
	[detail_num] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
