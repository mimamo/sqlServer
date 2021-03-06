USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[smFlatRate]    Script Date: 12/21/2015 16:06:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smFlatRate](
	[BasePrice] [float] NOT NULL,
	[BranchId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DatePrinted] [smalldatetime] NOT NULL,
	[EffectiveDate] [smalldatetime] NOT NULL,
	[FlatRateCategory] [char](10) NOT NULL,
	[FlatRateDesc] [char](50) NOT NULL,
	[FlatRateId] [char](10) NOT NULL,
	[FlatRateSubCategory] [char](10) NOT NULL,
	[FlatRateType] [char](1) NOT NULL,
	[LaborWarranty] [smallint] NOT NULL,
	[LaborWarrantyType] [char](1) NOT NULL,
	[LastUpdate] [smalldatetime] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MarkupPercent] [float] NOT NULL,
	[NoteID] [int] NOT NULL,
	[PartsWarranty] [smallint] NOT NULL,
	[PartsWarrantyType] [char](1) NOT NULL,
	[StandardHours] [float] NOT NULL,
	[TaxBasis] [char](1) NOT NULL,
	[TaxID] [char](10) NOT NULL,
	[TaxTotal] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
