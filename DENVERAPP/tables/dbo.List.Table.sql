USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[List]    Script Date: 12/21/2015 15:42:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[List](
	[Description00] [char](30) NOT NULL,
	[Description01] [char](30) NOT NULL,
	[Description02] [char](30) NOT NULL,
	[Description03] [char](30) NOT NULL,
	[Description04] [char](30) NOT NULL,
	[Description05] [char](30) NOT NULL,
	[Description06] [char](30) NOT NULL,
	[Description07] [char](30) NOT NULL,
	[Description08] [char](30) NOT NULL,
	[Description09] [char](30) NOT NULL,
	[Description10] [char](30) NOT NULL,
	[Description11] [char](30) NOT NULL,
	[Description12] [char](30) NOT NULL,
	[Description13] [char](30) NOT NULL,
	[Description14] [char](30) NOT NULL,
	[Description15] [char](30) NOT NULL,
	[Description16] [char](30) NOT NULL,
	[Description17] [char](30) NOT NULL,
	[Description18] [char](30) NOT NULL,
	[Description19] [char](30) NOT NULL,
	[ListID] [char](40) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[Value00] [char](4) NOT NULL,
	[Value01] [char](4) NOT NULL,
	[Value02] [char](4) NOT NULL,
	[Value03] [char](4) NOT NULL,
	[Value04] [char](4) NOT NULL,
	[Value05] [char](4) NOT NULL,
	[Value06] [char](4) NOT NULL,
	[Value07] [char](4) NOT NULL,
	[Value08] [char](4) NOT NULL,
	[Value09] [char](4) NOT NULL,
	[Value10] [char](4) NOT NULL,
	[Value11] [char](4) NOT NULL,
	[Value12] [char](4) NOT NULL,
	[Value13] [char](4) NOT NULL,
	[Value14] [char](4) NOT NULL,
	[Value15] [char](4) NOT NULL,
	[Value16] [char](4) NOT NULL,
	[Value17] [char](4) NOT NULL,
	[Value18] [char](4) NOT NULL,
	[Value19] [char](4) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [List0] PRIMARY KEY CLUSTERED 
(
	[ListID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
