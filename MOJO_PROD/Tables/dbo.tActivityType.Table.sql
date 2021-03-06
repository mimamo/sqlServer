USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tActivityType]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tActivityType](
	[ActivityTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [varchar](500) NOT NULL,
	[Active] [tinyint] NOT NULL,
	[CompanyKey] [int] NULL,
	[LastModified] [smalldatetime] NULL,
	[AutoRollDate] [tinyint] NULL,
	[TypeColor] [varchar](50) NULL,
	[DefaultStatusKey] [int] NULL,
	[Entity] [varchar](50) NULL,
 CONSTRAINT [PK_tActivityType] PRIMARY KEY CLUSTERED 
(
	[ActivityTypeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'To be used to separate the types for different areas.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tActivityType', @level2type=N'COLUMN',@level2name=N'Entity'
GO
