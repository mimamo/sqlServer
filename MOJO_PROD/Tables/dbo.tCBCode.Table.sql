USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCBCode]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCBCode](
	[CBCodeKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[CBCode] [varchar](400) NULL,
	[Active] [tinyint] NOT NULL,
	[ProjectNumber] [varchar](100) NULL,
	[TaskNumber] [varchar](100) NULL,
 CONSTRAINT [PK_tCBCode] PRIMARY KEY CLUSTERED 
(
	[CBCodeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
