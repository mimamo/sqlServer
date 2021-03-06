USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xTRAPS_REVTSK]    Script Date: 12/21/2015 13:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xTRAPS_REVTSK](
	[contract_type] [nchar](10) NOT NULL,
	[end_date] [smalldatetime] NOT NULL,
	[fips_num] [nchar](10) NOT NULL,
	[manager1] [nchar](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[pe_id01] [nchar](30) NOT NULL,
	[pjt_entity] [nchar](32) NOT NULL,
	[pjt_entity_desc] [nchar](30) NOT NULL,
	[project] [nchar](16) NOT NULL,
	[revid] [nchar](10) NOT NULL,
	[start_date] [smalldatetime] NOT NULL,
	[trigger_status] [nchar](10) NOT NULL
) ON [PRIMARY]
GO
