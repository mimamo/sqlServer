USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[tmp_GLJobRef]    Script Date: 12/21/2015 14:10:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmp_GLJobRef](
	[File] [nvarchar](255) NULL,
	[Journal] [nvarchar](255) NULL,
	[Batch] [nvarchar](255) NULL,
	[Fiscal] [nvarchar](255) NULL,
	[Month] [nvarchar](255) NULL,
	[InvoiceNum] [nvarchar](255) NULL,
	[Date] [datetime] NULL,
	[Description] [nvarchar](255) NULL,
	[Debit] [float] NULL,
	[Credit] [float] NULL
) ON [PRIMARY]
GO
