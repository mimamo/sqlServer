USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tFieldDef]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tFieldDef](
	[FieldDefKey] [int] IDENTITY(1,1) NOT NULL,
	[OwnerEntityKey] [int] NOT NULL,
	[AssociatedEntity] [varchar](50) NULL,
	[FieldName] [varchar](75) NOT NULL,
	[Description] [varchar](300) NULL,
	[DisplayType] [smallint] NOT NULL,
	[Caption] [varchar](75) NULL,
	[Hint] [varchar](300) NULL,
	[Size] [int] NOT NULL,
	[GridSize] [int] NULL,
	[MinSize] [int] NULL,
	[MaxSize] [int] NULL,
	[TextRows] [int] NULL,
	[ValueList] [text] NULL,
	[Required] [tinyint] NOT NULL,
	[Active] [tinyint] NOT NULL,
	[OnlyAuthorEdit] [tinyint] NULL,
	[MapTo] [int] NULL,
 CONSTRAINT [PK_tFieldDef] PRIMARY KEY NONCLUSTERED 
(
	[FieldDefKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tFieldDef] ADD  CONSTRAINT [DF_tFieldDef_DisplayType]  DEFAULT ((4)) FOR [DisplayType]
GO
ALTER TABLE [dbo].[tFieldDef] ADD  CONSTRAINT [DF_tFieldDef_Size]  DEFAULT ((20)) FOR [Size]
GO
ALTER TABLE [dbo].[tFieldDef] ADD  CONSTRAINT [DF_tFieldDef_MinSize]  DEFAULT ((0)) FOR [MinSize]
GO
ALTER TABLE [dbo].[tFieldDef] ADD  CONSTRAINT [DF_tFieldDef_MaxSize]  DEFAULT ((50)) FOR [MaxSize]
GO
ALTER TABLE [dbo].[tFieldDef] ADD  CONSTRAINT [DF_tFieldDef_TextRows]  DEFAULT ((1)) FOR [TextRows]
GO
ALTER TABLE [dbo].[tFieldDef] ADD  CONSTRAINT [DF_tFieldDef_Required]  DEFAULT ((0)) FOR [Required]
GO
ALTER TABLE [dbo].[tFieldDef] ADD  CONSTRAINT [DF_tFieldDef_Active]  DEFAULT ((1)) FOR [Active]
GO
