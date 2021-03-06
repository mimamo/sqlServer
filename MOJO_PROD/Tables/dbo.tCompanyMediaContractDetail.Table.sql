USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCompanyMediaContractDetail]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCompanyMediaContractDetail](
	[CompanyMediaContractDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyMediaContractKey] [int] NOT NULL,
	[MediaSpaceKey] [int] NULL,
	[MediaPositionKey] [int] NULL,
	[ShortQty] [decimal](24, 4) NULL,
	[TargetQty] [decimal](24, 4) NULL,
	[DiscountQty] [decimal](24, 4) NULL,
	[ShortRate] [money] NULL,
	[TargetRate] [money] NULL,
	[DiscountRate] [money] NULL,
 CONSTRAINT [PK_tCompanyMediaContractDetail] PRIMARY KEY CLUSTERED 
(
	[CompanyMediaContractDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tCompanyMediaContractDetail]  WITH CHECK ADD  CONSTRAINT [FK_tCompanyMediaContractDetail_tCompanyMediaContract] FOREIGN KEY([CompanyMediaContractKey])
REFERENCES [dbo].[tCompanyMediaContract] ([CompanyMediaContractKey])
GO
ALTER TABLE [dbo].[tCompanyMediaContractDetail] CHECK CONSTRAINT [FK_tCompanyMediaContractDetail_tCompanyMediaContract]
GO
