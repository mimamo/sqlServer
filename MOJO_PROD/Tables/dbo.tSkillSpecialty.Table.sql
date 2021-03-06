USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSkillSpecialty]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSkillSpecialty](
	[SkillSpecialtyKey] [int] IDENTITY(1,1) NOT NULL,
	[SkillKey] [int] NOT NULL,
	[SpecialtyName] [varchar](300) NOT NULL,
	[Keywords] [varchar](300) NULL,
	[Description] [varchar](1000) NULL,
	[TimeStamp] [timestamp] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tSkillSpecialty] PRIMARY KEY CLUSTERED 
(
	[SkillSpecialtyKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tSkillSpecialty]  WITH CHECK ADD  CONSTRAINT [FK_tSkillSpecialty_tSkill] FOREIGN KEY([SkillKey])
REFERENCES [dbo].[tSkill] ([SkillKey])
GO
ALTER TABLE [dbo].[tSkillSpecialty] CHECK CONSTRAINT [FK_tSkillSpecialty_tSkill]
GO
ALTER TABLE [dbo].[tSkillSpecialty] ADD  CONSTRAINT [DF_tSkillSpecialty_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
