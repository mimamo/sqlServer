USE [HoursReporting]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkActual'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkActual]
GO

CREATE PROCEDURE [dbo].[wrkActual] 
	@iCurMonth int,	
	@iCurYear int, 
	@classGrp varchar(10)
	
AS 

/*******************************************************************************************************
*   hoursReporting.dbo.ActualByEmployeeGet
*
*   Creator: Michelle Morales    
*   Date: 03/08/2016          
*   
*          
*   Notes: 

		select *
		from HoursReporting.dbo.Actual

*
*
*   Usage:	set statistics io on

	execute hoursReporting.dbo.wrkActual @iCurMonth = 10, @iCurYear = 2015,	@classGrp = '03KEL'


*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------

---------------------------------------------
-- create temp tables
---------------------------------------------

if object_id('tempdb.dbo.##HoursDataStage') > 0 drop table ##HoursDataStage

---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're usiSng a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------


---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkActual to BFGROUP
go

grant execute on wrkActual to MSDSL
go

grant control on wrkActual to MSDSL
go

grant execute on wrkActual to MSDynamicsSL
go