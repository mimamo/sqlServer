USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tUserSkill]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tUserSkill](
	[UserSkillKey] [int] IDENTITY(1,1) NOT NULL,
	[UserKey] [int] NOT NULL,
	[SkillKey] [int] NOT NULL,
	[Rating] [int] NOT NULL,
	[Description] [varchar](1000) NULL,
 CONSTRAINT [PK_tUserSkill] PRIMARY KEY CLUSTERED 
(
	[UserSkillKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tUserSkill]  WITH CHECK ADD  CONSTRAINT [FK_tUserSkill_tSkill] FOREIGN KEY([SkillKey])
REFERENCES [dbo].[tSkill] ([SkillKey])
GO
ALTER TABLE [dbo].[tUserSkill] CHECK CONSTRAINT [FK_tUserSkill_tSkill]
GO
ALTER TABLE [dbo].[tUserSkill]  WITH NOCHECK ADD  CONSTRAINT [FK_tUserSkill_tUser] FOREIGN KEY([UserKey])
REFERENCES [dbo].[tUser] ([UserKey])
GO
ALTER TABLE [dbo].[tUserSkill] CHECK CONSTRAINT [FK_tUserSkill_tUser]
GO
