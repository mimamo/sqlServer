USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tItem]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tItem](
	[ItemKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[LinkID] [varchar](100) NULL,
	[ItemType] [smallint] NOT NULL,
	[ItemID] [varchar](50) NOT NULL,
	[ItemName] [varchar](200) NOT NULL,
	[UnitCost] [money] NULL,
	[UnitRate] [money] NULL,
	[Markup] [decimal](24, 4) NULL,
	[UnitDescription] [varchar](30) NULL,
	[StandardDescription] [varchar](1000) NULL,
	[WorkTypeKey] [int] NULL,
	[ExpenseAccountKey] [int] NULL,
	[QuantityOnHand] [decimal](24, 4) NULL,
	[Active] [tinyint] NULL,
	[SalesAccountKey] [int] NULL,
	[ClassKey] [int] NULL,
	[Taxable] [tinyint] NULL,
	[Taxable2] [tinyint] NULL,
	[DepartmentKey] [int] NULL,
	[UseUnitRate] [tinyint] NULL,
	[CalcAsArea] [tinyint] NULL,
	[ConversionMultiplier] [decimal](24, 4) NULL,
	[MinAmount] [money] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[UseDescription] [tinyint] NULL,
 CONSTRAINT [PK_tItem] PRIMARY KEY NONCLUSTERED 
(
	[ItemKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tItem]  WITH CHECK ADD  CONSTRAINT [FK_tItem_tCompany] FOREIGN KEY([CompanyKey])
REFERENCES [dbo].[tCompany] ([CompanyKey])
GO
ALTER TABLE [dbo].[tItem] CHECK CONSTRAINT [FK_tItem_tCompany]
GO
ALTER TABLE [dbo].[tItem] ADD  CONSTRAINT [DF_tItem_ItemType]  DEFAULT ((0)) FOR [ItemType]
GO
ALTER TABLE [dbo].[tItem] ADD  CONSTRAINT [DF_tItem_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[tItem] ADD  CONSTRAINT [DF_tItem_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
ALTER TABLE [dbo].[tItem] ADD  CONSTRAINT [DF_tItem_UseDescription]  DEFAULT ((1)) FOR [UseDescription]
GO
