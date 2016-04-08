USE [StageDM]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   StageDM.dbo.Associate
*
*   Creator:	Michelle Morales
*   Date:		03/21/2016
*		
*
*   Notes:      


*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*  
********************************************************************************************************/

if (select 1
	from information_schema.tables
	where table_name = 'Associate') < 1
	
CREATE TABLE [dbo].[Associate](
	userName varchar(30) not null,
	firstName varchar(50),
	lastName varchar(50),
	title varchar(80),
	id int null,
	DateAdded datetime,
	rowId int identity(1,1),
	CONSTRAINT [Associate_UserName_rowId] PRIMARY KEY CLUSTERED (userName, rowId)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80)
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

---------------------------------------------
-- modifications
---------------------------------------------


/*
if not exists (select *
				from sys.indexes 
				where object_id = OBJECT_ID(N'[Associate]') 
					and name = 'nci_Associate_Brand_clientID_prodID')
begin

CREATE NONCLUSTERED INDEX nci_Associate_Brand_clientID_prodID ON [dbo].[Associate]
     ([Brand], [clientID], [prodID])
 INCLUDE ([POS]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

end
go
*/
---------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Associate TO BFGROUP
GRANT SELECT on dbo.Associate TO public

