use denverapp
go

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'xWRKMG_Update_CFProdDesc'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[xWRKMG_Update_CFProdDesc]
GO

CREATE PROCEDURE [dbo].[xWRKMG_Update_CFProdDesc] 
   
    
AS

/*******************************************************************************************************
*   denverapp.dbo.xWRKMG_Update_CFProdDesc
*
*   Creator:	Michelle Morales
*   Date:		11/19/2015
*
*
*   Notes:      select *
				from sqlwmj.mojo_prod.dbo.tProject     
				where projectNumber = 'TSTP06837815MMM'

*   Usage:	execute denverapp.dbo.xWRKMG_Update_CFProdDesc
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
declare @message varchar(80)

---------------------------------------------
-- set session variables
---------------------------------------------

SET NOCOUNT ON
set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------

begin transaction
		
		update wmjp
			set [description] = rtrim(d.descr)
		from sqlwmj.mojo_prod.dbo.tProject wmjp
		inner join denverapp.dbo.pjProj dslp
			on right(wmjp.projectNumber,11) = dslp.project 
		inner join denverapp.dbo.xIGProdCode d
			on coalesce(dslp.pm_id02,'') = coalesce(d.code_id,'')
		where (wmjp.projectNumber,11) = @Project
		
		
		if @@error <> 0
		begin  
		
			set @message = 'Error updating mojo_prod.dbo.tProject description field.'
			rollback tran	
			
			DECLARE @ErrorNumberA int
			DECLARE @ErrorSeverityA int
			DECLARE @ErrorStateA varchar(255)
			DECLARE @ErrorProcedureA varchar(255)
			DECLARE @ErrorLineA int
			DECLARE @ErrorMessageA varchar(max)
			DECLARE @ErrorDateA smalldatetime
			DECLARE @UserNameA varchar(50)
			DECLARE @ErrorAppA varchar(50)
			DECLARE @UserMachineName varchar(50)

			SET @ErrorNumberA = Error_number()
			SET @ErrorSeverityA = Error_severity()
			SET @ErrorStateA = Error_state()
			SET @ErrorProcedureA = Error_procedure()
			SET @ErrorLineA = Error_line()
			SET @ErrorMessageA = rtrim(coalesce(Error_message(),'') + ' ' + @message)
			SET @ErrorDateA = GetDate()
			SET @UserNameA = suser_sname() 
			SET @ErrorAppA = app_name()
			SET @UserMachineName = host_name()
			
			exec denverapp.dbo.xLogErrorandEmail @ErrorNumberA, @ErrorSeverityA, @ErrorStateA, @ErrorProcedureA, @ErrorLineA, 
				@ErrorMessageA, @ErrorDateA, @UserNameA, @ErrorAppA, @UserMachineName

		end     

commit transaction
	
/*
select top 100 * 
from DENVERAPP.dbo.xDSLErrorLog with (nolock) 
order by id desc

select top 100 * 
from shopper_dev_app.dbo.xDSLErrorLog with (nolock) 
order by id desc
*/

GO


RETURN
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

---------------------------------------------
-- permissions
---------------------------------------------
