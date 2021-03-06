USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xCPG]    Script Date: 12/21/2015 16:12:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xCPG](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Type] [int] NOT NULL,
	[clientID] [varchar](15) NOT NULL,
	[clientName] [char](30) NOT NULL,
	[clientStatus] [char](1) NOT NULL,
	[prodID] [varchar](10) NOT NULL,
	[product] [char](30) NOT NULL,
	[productStatus] [char](1) NOT NULL,
	[productGroup] [char](30) NOT NULL,
 CONSTRAINT [PK_xwrk_CPG] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
