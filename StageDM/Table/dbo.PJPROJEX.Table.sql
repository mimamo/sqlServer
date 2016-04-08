USE [StageDM]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   drop table StageDM.dbo.PJPROJEX
*
*   Creator:	Michelle Morales     
*   Date:       03/21/2016  
*   
*
*   Notes:      select top 100 * from StageDM.dbo.PJPROJEX    
*
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
if (select 1
	from information_schema.tables
	where table_name = 'PJPROJEX') < 1
	
CREATE TABLE [dbo].[PJPROJEX](
	[computed_date] [smalldatetime] NOT NULL,
	[computed_pc] [float] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[entered_pc] [float] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[PM_ID11] [char](30) NOT NULL,
	[PM_ID12] [char](30) NOT NULL,
	[PM_ID13] [char](16) NOT NULL,
	[PM_ID14] [char](16) NOT NULL,
	[PM_ID15] [char](4) NOT NULL,
	[PM_ID16] [float] NOT NULL,
	[PM_ID17] [float] NOT NULL,
	[PM_ID18] [smalldatetime] NOT NULL,
	[PM_ID19] [smalldatetime] NOT NULL,
	[PM_ID20] [int] NOT NULL,
	[PM_ID21] [char](30) NOT NULL,
	[PM_ID22] [char](30) NOT NULL,
	[PM_ID23] [char](16) NOT NULL,
	[PM_ID24] [char](16) NOT NULL,
	[PM_ID25] [char](4) NOT NULL,
	[PM_ID26] [float] NOT NULL,
	[PM_ID27] [float] NOT NULL,
	[PM_ID28] [smalldatetime] NOT NULL,
	[PM_ID29] [smalldatetime] NOT NULL,
	[PM_ID30] [int] NOT NULL,
	[proj_date1] [smalldatetime] NOT NULL,
	[proj_date2] [smalldatetime] NOT NULL,
	[proj_date3] [smalldatetime] NOT NULL,
	[proj_date4] [smalldatetime] NOT NULL,
	[project] [char](16) NOT NULL,
	[rate_table_labor] [char](4) NOT NULL,
	[revision_date] [smalldatetime] NOT NULL,
	[rev_flag] [char](1) NOT NULL,
	[rev_type] [char](2) NOT NULL,
	[work_comp_cd] [char](6) NOT NULL,
	[work_location] [char](6) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
	[Company] varchar(40),
 CONSTRAINT [pjprojex0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	company
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO



---------------------------------------------
-- modifications
---------------------------------------------

--------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.PJPROJEX TO BFGROUP
GRANT SELECT on dbo.PJPROJEX TO public
