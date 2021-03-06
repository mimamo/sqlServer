USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tAppSetting]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tAppSetting](
	[GroupID] [varchar](50) NOT NULL,
	[SessionID] [varchar](50) NOT NULL,
	[EditorType] [varchar](50) NOT NULL,
	[DefaultValue] [varchar](500) NULL,
	[ValueList] [varchar](max) NULL,
	[LookupID] [varchar](100) NULL,
	[DisplayOrder] [int] NOT NULL,
	[Label] [varchar](300) NOT NULL,
	[Hint] [varchar](max) NULL,
	[DefaultLabel] [varchar](500) NULL,
	[CFEntity1] [varchar](50) NULL,
	[CFPrefix1] [varchar](50) NULL,
	[Required] [tinyint] NOT NULL,
	[UserSessionID] [varchar](50) NULL,
	[VisibleField] [varchar](100) NULL,
 CONSTRAINT [PK_tAppSetting] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC,
	[SessionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tAppSetting] ADD  CONSTRAINT [DF_tAppSetting_Required]  DEFAULT ((0)) FOR [Required]
GO
