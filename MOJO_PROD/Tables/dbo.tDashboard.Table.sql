USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDashboard]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tDashboard](
	[DashboardKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[DashboardType] [smallint] NOT NULL,
	[DashboardName] [varchar](200) NOT NULL,
	[ColumnActive1] [tinyint] NOT NULL,
	[ColumnActive2] [tinyint] NOT NULL,
	[ColumnActive3] [tinyint] NOT NULL,
	[ColumnWidth1] [int] NOT NULL,
	[ColumnWidth2] [int] NOT NULL,
	[ColumnWidth3] [int] NOT NULL,
 CONSTRAINT [PK_tDashboard] PRIMARY KEY CLUSTERED 
(
	[DashboardKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
