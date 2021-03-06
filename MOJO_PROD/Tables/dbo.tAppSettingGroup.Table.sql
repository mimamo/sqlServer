USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tAppSettingGroup]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tAppSettingGroup](
	[GroupID] [varchar](50) NOT NULL,
	[Title] [varchar](300) NOT NULL,
	[Rights] [varchar](100) NOT NULL,
	[ResetSettings] [tinyint] NOT NULL,
 CONSTRAINT [PK_tAppSettingGroup] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tAppSettingGroup] ADD  CONSTRAINT [DF_tAppSettingGroup_ResetSettings]  DEFAULT ((0)) FOR [ResetSettings]
GO
