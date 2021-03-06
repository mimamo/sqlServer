USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tQuoteDetail]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tQuoteDetail](
	[QuoteDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[QuoteKey] [int] NOT NULL,
	[LineNumber] [int] NULL,
	[ProjectKey] [int] NULL,
	[TaskKey] [int] NULL,
	[ItemKey] [int] NULL,
	[ClassKey] [int] NULL,
	[ShortDescription] [varchar](200) NULL,
	[LongDescription] [varchar](6000) NULL,
	[Quantity] [decimal](24, 4) NULL,
	[UnitDescription] [varchar](30) NULL,
	[CustomFieldKey] [int] NULL,
	[Quantity2] [decimal](24, 4) NULL,
	[UnitDescription2] [varchar](30) NULL,
	[Quantity3] [decimal](24, 4) NULL,
	[UnitDescription3] [varchar](30) NULL,
	[Quantity4] [decimal](24, 4) NULL,
	[UnitDescription4] [varchar](30) NULL,
	[Quantity5] [decimal](24, 4) NULL,
	[UnitDescription5] [varchar](30) NULL,
	[Quantity6] [decimal](24, 4) NULL,
	[UnitDescription6] [varchar](30) NULL,
	[OfficeKey] [int] NULL,
	[DepartmentKey] [int] NULL,
 CONSTRAINT [PK_tQuoteDetail] PRIMARY KEY NONCLUSTERED 
(
	[QuoteDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
