USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[RetainerExcludeProject]    Script Date: 12/21/2015 13:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RetainerExcludeProject](
	[RetainerProjectExcludeID] [int] IDENTITY(1,1) NOT NULL,
	[RetainerID] [int] NOT NULL,
	[RetainerProjectID] [char](16) NOT NULL,
 CONSTRAINT [PK_RetainerExcludeProject] PRIMARY KEY CLUSTERED 
(
	[RetainerProjectExcludeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[RetainerExcludeProject]  WITH CHECK ADD  CONSTRAINT [FK_RetainerExcludeProject_Retainers] FOREIGN KEY([RetainerID])
REFERENCES [dbo].[Retainers] ([RetainerID])
GO
ALTER TABLE [dbo].[RetainerExcludeProject] CHECK CONSTRAINT [FK_RetainerExcludeProject_Retainers]
GO
