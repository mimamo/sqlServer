USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[xCog_AccessTables]    Script Date: 12/21/2015 14:17:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xCog_AccessTables](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Location] [nvarchar](60) NOT NULL,
	[DList] [nvarchar](30) NOT NULL,
	[ItemName] [nvarchar](60) NOT NULL,
	[AccessLevel] [nvarchar](15) NULL,
	[Active] [bit] NOT NULL,
	[timestamp] [timestamp] NOT NULL,
	[AGYEList] [nvarchar](60) NULL,
 CONSTRAINT [PK_xCog_AccessTables] PRIMARY KEY CLUSTERED 
(
	[Location] ASC,
	[DList] ASC,
	[ItemName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
