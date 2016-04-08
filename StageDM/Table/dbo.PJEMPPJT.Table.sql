USE [StageDM]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   drop table StageDM.dbo.PJEMPPJT
*
*   Creator:	Michelle Morales     
*   Date:       03/21/2016  
*   
*
*   Notes:      select top 100 * from StageDM.dbo.PJEMPPJT    
*
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
if (select 1
	from information_schema.tables
	where table_name = 'PJEMPPJT') < 1
	
CREATE TABLE [dbo].[PJEMPPJT](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[employee] [char](10) NOT NULL,
	[ep_id01] [char](30) NOT NULL,
	[ep_id02] [char](30) NOT NULL,
	[ep_id03] [char](16) NOT NULL,
	[ep_id04] [char](16) NOT NULL,
	[ep_id05] [char](4) NOT NULL,
	[ep_id06] [float] NOT NULL,
	[ep_id07] [float] NOT NULL,
	[ep_id08] [smalldatetime] NOT NULL,
	[ep_id09] [smalldatetime] NOT NULL,
	[ep_id10] [int] NOT NULL,
	[effect_date] [smalldatetime] NOT NULL,
	[labor_class_cd] [char](4) NOT NULL,
	[labor_rate] [float] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[project] [char](16) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
	[Company] varchar(50),
 CONSTRAINT [pjemppjt0] PRIMARY KEY CLUSTERED 
(
	[employee] ASC,
	[project] ASC,
	[effect_date] ASC,
	company
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

--------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.PJEMPPJT TO BFGROUP
GRANT SELECT on dbo.PJEMPPJT TO public
