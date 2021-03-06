USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tLab]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tLab](
	[LabKey] [int] NOT NULL,
	[LabID] [varchar](50) NOT NULL,
	[LabName] [varchar](500) NOT NULL,
	[LabDescription] [text] NULL,
	[LabGroup] [varchar](500) NULL,
	[DisplayOrder] [int] NULL,
	[Beta] [tinyint] NULL,
	[LabReleaseDate] [varchar](50) NULL,
 CONSTRAINT [PK_tLab] PRIMARY KEY CLUSTERED 
(
	[LabKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
