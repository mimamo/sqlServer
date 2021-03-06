USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tItemRateSheet]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tItemRateSheet](
	[ItemRateSheetKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[RateSheetName] [varchar](50) NOT NULL,
	[Active] [tinyint] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tItemRateSheet] PRIMARY KEY CLUSTERED 
(
	[ItemRateSheetKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tItemRateSheet] ADD  CONSTRAINT [DF_tItemRateSheet_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
