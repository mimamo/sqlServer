USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tPurchaseOrderType]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tPurchaseOrderType](
	[PurchaseOrderTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[PurchaseOrderTypeName] [varchar](200) NOT NULL,
	[Description] [varchar](1000) NULL,
	[HeaderFieldSetKey] [int] NULL,
	[DetailFieldSetKey] [int] NULL,
	[Active] [tinyint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[StandardHeaderTextKey] [int] NULL,
	[StandardFooterTextKey] [int] NULL,
 CONSTRAINT [PK_tPurchaseOrderType] PRIMARY KEY NONCLUSTERED 
(
	[PurchaseOrderTypeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tPurchaseOrderType]  WITH CHECK ADD  CONSTRAINT [FK_tPurchaseOrderType_tCompany] FOREIGN KEY([CompanyKey])
REFERENCES [dbo].[tCompany] ([CompanyKey])
GO
ALTER TABLE [dbo].[tPurchaseOrderType] CHECK CONSTRAINT [FK_tPurchaseOrderType_tCompany]
GO
ALTER TABLE [dbo].[tPurchaseOrderType] ADD  CONSTRAINT [DF_tPurchaseOrderType_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
