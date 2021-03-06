USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xwrk_TransactionDetails]    Script Date: 12/21/2015 13:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_TransactionDetails](
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
