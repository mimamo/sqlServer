USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tClientProduct]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tClientProduct](
	[ClientProductKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[ClientDivisionKey] [int] NULL,
	[ProductName] [varchar](300) NOT NULL,
	[Active] [tinyint] NOT NULL,
	[LinkID] [varchar](100) NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[ProductID] [varchar](50) NULL,
 CONSTRAINT [PK_tClientProduct] PRIMARY KEY CLUSTERED 
(
	[ClientProductKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tClientProduct] ADD  CONSTRAINT [DF_tClientProduct_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
