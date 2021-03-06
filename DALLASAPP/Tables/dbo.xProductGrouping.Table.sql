USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xProductGrouping]    Script Date: 12/21/2015 13:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xProductGrouping](
	[ClientName] [nvarchar](50) NOT NULL,
	[GroupDesc] [nvarchar](50) NOT NULL,
	[DirectGroupDesc] [nvarchar](50) NOT NULL,
	[ProductId] [nvarchar](5) NOT NULL,
	[ProdDescr] [nvarchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_user] [char](10) NOT NULL,
 CONSTRAINT [PK_vtbl_codeGrp] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
