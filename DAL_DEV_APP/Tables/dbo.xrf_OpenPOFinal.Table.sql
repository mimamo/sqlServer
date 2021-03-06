USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[xrf_OpenPOFinal]    Script Date: 12/21/2015 13:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xrf_OpenPOFinal](
	[PONumber] [nvarchar](255) NULL,
	[ClientCode] [nvarchar](255) NULL,
	[ClientName] [nvarchar](255) NULL,
	[ProductCode] [nvarchar](255) NULL,
	[ProductDescription] [nvarchar](255) NULL,
	[JobCode] [nvarchar](255) NULL,
	[JobDescription] [nvarchar](255) NULL,
	[VendorID] [nvarchar](255) NULL,
	[VendorName] [nvarchar](255) NULL,
	[Function] [nvarchar](255) NULL,
	[FunctionDescription] [nvarchar](255) NULL,
	[OnShelfDate] [datetime] NULL,
	[Buyer] [nvarchar](255) NULL,
	[CreateDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[HeaderComments] [nvarchar](max) NULL,
	[Quantity] [float] NULL,
	[UnitPrice] [float] NULL,
	[ExtendedValue] [float] NULL,
	[DetailLineComments] [nvarchar](max) NULL,
	[DeliveryInstructions] [nvarchar](max) NULL,
	[Requisitioner] [nvarchar](255) NULL,
	[SolProject] [nvarchar](255) NULL,
	[SolVendID] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[LineNbr] [float] NULL
) ON [PRIMARY]
GO
