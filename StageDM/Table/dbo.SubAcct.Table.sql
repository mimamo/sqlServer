USE [StageDM]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   drop table StageDM.dbo.SubAcct
*
*   Creator:	Michelle Morales     
*   Date:       03/21/2016  
*   
*
*   Notes:      select top 100 * from StageDM.dbo.SubAcct    
*
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
if (select 1
	from information_schema.tables
	where table_name = 'SubAcct') < 1
	
CREATE TABLE [dbo].[SubAcct](
	[Active] [smallint] NOT NULL,
	[ConsolSub] [char](24) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
	[Company] varchar(40),
 CONSTRAINT [Subacct0] PRIMARY KEY CLUSTERED 
(
	[Sub] ASC,
	Company
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

---------------------------------------------
-- modifications
---------------------------------------------
IF NOT EXISTS (SELECT * 
			FROM sys.indexes 
			WHERE object_id = OBJECT_ID(N'[dbo].[SubAcct]') 
				AND name = N'idx_SubAcct_sub')
				
CREATE NONCLUSTERED INDEX [idx_SubAcct_sub]
ON [dbo].[SubAcct] ([sub]) INCLUDE ([Descr])
GO

--------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.SubAcct TO BFGROUP
GRANT SELECT on dbo.SubAcct TO public
