USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTeamUser]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTeamUser](
	[TeamKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
 CONSTRAINT [PK_tTeamUser] PRIMARY KEY CLUSTERED 
(
	[TeamKey] ASC,
	[UserKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tTeamUser]  WITH CHECK ADD  CONSTRAINT [FK_tTeamUser_tTeam] FOREIGN KEY([TeamKey])
REFERENCES [dbo].[tTeam] ([TeamKey])
GO
ALTER TABLE [dbo].[tTeamUser] CHECK CONSTRAINT [FK_tTeamUser_tTeam]
GO
