USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tISCI]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tISCI](
	[ISCIKey] [int] NOT NULL,
	[ProjectKey] [int] NOT NULL,
	[ISCICode] [varchar](100) NOT NULL,
	[Title] [varchar](500) NOT NULL,
	[Description] [varchar](4000) NULL,
	[CustomFieldKey] [int] NULL,
 CONSTRAINT [PK_tISCI] PRIMARY KEY CLUSTERED 
(
	[ISCIKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
