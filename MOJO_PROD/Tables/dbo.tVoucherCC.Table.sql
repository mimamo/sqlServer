USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tVoucherCC]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tVoucherCC](
	[VoucherKey] [int] NOT NULL,
	[VoucherCCKey] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[Exclude1099] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tVoucherCC] ADD  CONSTRAINT [DF_tVoucherCC_Amount]  DEFAULT ((0)) FOR [Amount]
GO
