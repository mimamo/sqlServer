USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[tmp_APSBilling]    Script Date: 12/21/2015 13:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_APSBilling](
	[Contract] [nvarchar](255) NULL,
	[Type] [nvarchar](255) NULL,
	[RefNbr] [nvarchar](255) NULL,
	[PerEnt] [nvarchar](255) NULL,
	[Date] [datetime] NULL,
	[Description] [nvarchar](255) NULL,
	[Job] [nvarchar](255) NULL,
	[Balance] [float] NULL,
	[Amount] [float] NULL,
	[ClientID] [varchar](50) NULL,
	[ClientName] [varchar](100) NULL,
	[ProductID] [varchar](50) NULL,
	[ProductName] [varchar](100) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
