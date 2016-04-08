USE [StageDM]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   drop table StageDM.dbo.PJEMPLOY
*
*   Creator:	Michelle Morales     
*   Date:       03/21/2016  
*   
*
*   Notes:      
				select top 100 * 
				from StageDM.dbo.PJEMPLOY    
*
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
if (select 1
	from information_schema.tables
	where table_name = 'PJEMPLOY') < 1
	
CREATE TABLE [dbo].[PJEMPLOY](
	[BaseCuryId] [char](4) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[date_hired] [smalldatetime] NOT NULL,
	[date_terminated] [smalldatetime] NOT NULL,
	[employee] [char](10) NOT NULL,
	[emp_name] [char](60) NOT NULL,
	[emp_status] [char](1) NOT NULL,
	[emp_type_cd] [char](4) NOT NULL,
	[em_id01] [char](30) NOT NULL,
	[em_id02] [char](30) NOT NULL,
	[em_id03] [char](50) NOT NULL,
	[em_id04] [char](16) NOT NULL,
	[em_id05] [char](4) NOT NULL,
	[em_id06] [float] NOT NULL,
	[em_id07] [float] NOT NULL,
	[em_id08] [smalldatetime] NOT NULL,
	[em_id09] [smalldatetime] NOT NULL,
	[em_id10] [int] NOT NULL,
	[em_id11] [char](30) NOT NULL,
	[em_id12] [char](30) NOT NULL,
	[em_id13] [char](20) NOT NULL,
	[em_id14] [char](20) NOT NULL,
	[em_id15] [char](10) NOT NULL,
	[em_id16] [char](10) NOT NULL,
	[em_id17] [char](4) NOT NULL,
	[em_id18] [float] NOT NULL,
	[em_id19] [smalldatetime] NOT NULL,
	[em_id20] [int] NOT NULL,
	[em_id21] [char](10) NOT NULL,
	[em_id22] [char](10) NOT NULL,
	[em_id23] [char](10) NOT NULL,
	[em_id24] [char](10) NOT NULL,
	[em_id25] [char](10) NOT NULL,
	[exp_approval_max] [float] NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[manager1] [char](10) NOT NULL,
	[manager2] [char](10) NOT NULL,
	[MSPData] [char](50) NOT NULL,
	[MSPInterface] [char](1) NOT NULL,
	[MSPRes_UID] [int] NOT NULL,
	[MSPType] [char](1) NOT NULL,
	[noteid] [int] NOT NULL,
	[placeholder] [char](1) NOT NULL,
	[stdday] [smallint] NOT NULL,
	[Stdweek] [smallint] NOT NULL,
	[Subcontractor] [char](1) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[user_id] [char](50) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
	[Company] varchar(50),
 CONSTRAINT [pjemploy0] PRIMARY KEY CLUSTERED 
(
	[employee] ASC,
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

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.PJEMPLOY TO BFGROUP
GRANT SELECT on dbo.PJEMPLOY TO public
