USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[RetainerIncludeProject]    Script Date: 12/21/2015 16:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RetainerIncludeProject](
	[RetainerProjectIncludeID] [int] IDENTITY(1,1) NOT NULL,
	[RetainerID] [int] NOT NULL,
	[RetainerProjectID] [char](16) NOT NULL,
 CONSTRAINT [PK_RetainerIncludeJobs] PRIMARY KEY CLUSTERED 
(
	[RetainerProjectIncludeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[RetainerIncludeProject]  WITH CHECK ADD  CONSTRAINT [FK_RetainerIncludeProject_Retainers] FOREIGN KEY([RetainerID])
REFERENCES [dbo].[Retainers] ([RetainerID])
GO
ALTER TABLE [dbo].[RetainerIncludeProject] CHECK CONSTRAINT [FK_RetainerIncludeProject_Retainers]
GO
