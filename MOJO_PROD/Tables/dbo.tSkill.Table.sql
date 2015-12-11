USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSkill]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSkill](
	[SkillKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[SkillName] [varchar](300) NOT NULL,
	[Keywords] [varchar](300) NULL,
	[Description] [varchar](1000) NULL,
	[TimeStamp] [timestamp] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tSkill] PRIMARY KEY CLUSTERED 
(
	[SkillKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tSkill] ADD  CONSTRAINT [DF_tSkill_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
