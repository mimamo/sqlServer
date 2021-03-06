USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[xtmpIPM]    Script Date: 12/21/2015 13:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpIPM](
	[Client] [nvarchar](255) NULL,
	[Product Code] [nvarchar](255) NULL,
	[Product] [nvarchar](255) NULL,
	[Job] [nvarchar](255) NULL,
	[Job Description] [nvarchar](255) NULL,
	[Function] [nvarchar](255) NULL,
	[Amount Billed] [float] NULL,
	[Type] [varchar](16) NULL,
	[SubType] [varchar](4) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
