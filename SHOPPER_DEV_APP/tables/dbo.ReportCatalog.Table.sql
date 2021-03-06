USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[ReportCatalog]    Script Date: 12/21/2015 14:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportCatalog](
	[PRODNAME] [char](31) NOT NULL,
	[Business_Desk_Report_Nam] [char](51) NOT NULL,
	[Report_Option] [char](51) NOT NULL,
	[Business_Desk_Report_Typ] [char](5) NOT NULL,
	[Report_URL] [char](255) NOT NULL,
	[Last_Date_Published] [datetime] NOT NULL,
	[Last_Time_Published] [datetime] NOT NULL,
	[Report_Series] [smallint] NOT NULL,
	[Reviewed] [tinyint] NOT NULL,
	[DEX_ROW_ID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PKReportCatalog] PRIMARY KEY CLUSTERED 
(
	[PRODNAME] ASC,
	[Business_Desk_Report_Nam] ASC,
	[Report_Option] ASC,
	[Last_Date_Published] ASC,
	[Last_Time_Published] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
