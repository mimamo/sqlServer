USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[xTransactionDetails]    Script Date: 12/21/2015 16:06:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xTransactionDetails](
	[TranMigrationIDChar] [nvarchar](50) NOT NULL,
	[TranMigrationID] [bigint] NOT NULL,
	[TranType] [nvarchar](5) NOT NULL,
	[TranDate] [datetime] NOT NULL,
	[Tran_Comment1] [nvarchar](100) NOT NULL,
	[Tran_Data] [nvarchar](100) NOT NULL,
	[Client_Invoice] [nvarchar](100) NOT NULL,
	[Tran_Data2] [nvarchar](100) NOT NULL,
	[Client_Amt] [float] NOT NULL,
	[Hours] [float] NOT NULL,
	[Bill_Amt] [float] NOT NULL,
	[Net_Amt] [float] NOT NULL,
	[Commission_Amt] [float] NOT NULL,
	[Tran_Comment2] [nvarchar](300) NOT NULL,
	[Customer] [nvarchar](50) NOT NULL,
	[Product] [nvarchar](50) NOT NULL,
	[Job] [nvarchar](50) NOT NULL,
	[Task] [nvarchar](50) NOT NULL,
	[Status] [int] NOT NULL,
	[EncodaJobNumber] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xTransactionDetails] ADD  CONSTRAINT [DF_xTransactionDetails_TranMigrationIDChar]  DEFAULT ('') FOR [TranMigrationIDChar]
GO
