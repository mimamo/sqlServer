USE [StageDM]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   drop table StageDM.dbo.PJCODE
*
*   Creator:	Michelle Morales     
*   Date:       03/21/2016  
*   
*
*   Notes:      
				select top 100 * from StageDM.dbo.PJCODE    
				select top 100 * from den_dev_app.dbo.PJCODE    
*
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
if (select 1
	from information_schema.tables
	where table_name = 'PJCODE') < 1
	
CREATE TABLE [dbo].[PJCODE](
	[code_type] [char](4) NOT NULL,
	[code_value] [char](30) NOT NULL,
	[code_value_desc] [char](30) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[data1] [char](30) NOT NULL,
	[data2] [char](16) NOT NULL,
	[data3] [smalldatetime] NOT NULL,
	[data4] [float] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
	[Company] varchar(50),
 CONSTRAINT [pjcode0] PRIMARY KEY CLUSTERED 
(
	[code_type] ASC,
	[code_value] ASC,
	company
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO


--------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.PJCODE TO BFGROUP
GRANT SELECT on dbo.PJCODE TO public
