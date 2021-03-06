USE [StageDM]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   drop table StageDM.dbo.xIGProdCode
*
*   Creator:	Michelle Morales     
*   Date:       03/21/2016  
*   
*
*   Notes:      select top 100 * from StageDM.dbo.xIGProdCode    
*
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
if (select 1
	from information_schema.tables
	where table_name = 'xIGProdCode') < 1
	
CREATE TABLE [dbo].[xIGProdCode](
	[activate_by] [char](16) NOT NULL,
	[activate_date] [smalldatetime] NOT NULL,
	[code_group] [char](30) NOT NULL,
	[code_ID] [char](4) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[deactivate_by] [char](16) NOT NULL,
	[deactivate_date] [smalldatetime] NOT NULL,
	[descr] [char](30) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[status] [char](1) NOT NULL,
	[Type] [char](1) NOT NULL,
	[user01] [char](30) NOT NULL,
	[user02] [char](30) NOT NULL,
	[user03] [float] NOT NULL,
	[user04] [float] NOT NULL,
	[user05] [char](10) NOT NULL,
	[user06] [char](10) NOT NULL,
	[user07] [smalldatetime] NOT NULL,
	[user08] [smalldatetime] NOT NULL,
	[user09] [smallint] NOT NULL,
	[user10] [smallint] NOT NULL,
	[user11] [char](2) NOT NULL,
	[user12] [char](2) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
	[Company] varchar(40),
	CONSTRAINT [xIGProdCode_codeGroup_CodeId] PRIMARY KEY CLUSTERED (code_group, code_ID, company)
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

--------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.xIGProdCode TO BFGROUP
GRANT SELECT on dbo.xIGProdCode TO public
