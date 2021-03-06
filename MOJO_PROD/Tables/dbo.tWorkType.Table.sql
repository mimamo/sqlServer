USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tWorkType]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tWorkType](
	[WorkTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[WorkTypeID] [varchar](100) NOT NULL,
	[WorkTypeName] [varchar](200) NOT NULL,
	[Description] [text] NULL,
	[StandardPrice] [money] NULL,
	[GLAccountKey] [int] NULL,
	[ClassKey] [int] NULL,
	[Active] [tinyint] NULL,
	[Taxable] [tinyint] NULL,
	[Taxable2] [tinyint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[DepartmentKey] [int] NULL,
	[DisplayOrder] [int] NULL,
 CONSTRAINT [PK_tWorkType] PRIMARY KEY NONCLUSTERED 
(
	[WorkTypeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tWorkType] ADD  CONSTRAINT [DF_tWorkType_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[tWorkType] ADD  CONSTRAINT [DF_tWorkType_Taxable]  DEFAULT ((0)) FOR [Taxable]
GO
ALTER TABLE [dbo].[tWorkType] ADD  CONSTRAINT [DF_tWorkType_Taxable2]  DEFAULT ((0)) FOR [Taxable2]
GO
ALTER TABLE [dbo].[tWorkType] ADD  CONSTRAINT [DF_tWorkType_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
