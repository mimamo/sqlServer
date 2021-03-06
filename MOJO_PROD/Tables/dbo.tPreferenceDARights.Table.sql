USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tPreferenceDARights]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tPreferenceDARights](
	[CompanyKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[AllowRead] [tinyint] NOT NULL,
	[AllowAdd] [tinyint] NOT NULL,
	[AllowAddFile] [tinyint] NOT NULL,
	[AllowChange] [tinyint] NOT NULL,
	[AllowDelete] [tinyint] NOT NULL,
 CONSTRAINT [PK_tPreferenceDARights] PRIMARY KEY CLUSTERED 
(
	[CompanyKey] ASC,
	[Entity] ASC,
	[EntityKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tPreferenceDARights] ADD  CONSTRAINT [DF_tPreferenceDARights_AllowAddFile]  DEFAULT ((1)) FOR [AllowAddFile]
GO
