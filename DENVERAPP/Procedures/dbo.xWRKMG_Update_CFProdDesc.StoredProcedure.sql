USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xWRKMG_Update_CFProdDesc]    Script Date: 12/21/2015 15:43:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
*   Notes:      execute denverapp.dbo.xWRKMG_Update_CFProdDesc
*                  
*
*   Usage:
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
declare @maxProjectKey int,
	@message varchar(80)

---------------------------------------------
-- set session variables
---------------------------------------------

SET NOCOUNT ON
set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
select @maxProjectKey = null
select @maxProjectKey = max(ProjectKey)
from sqlwmj.mojo_prod.dbo.tProject

begin transaction

		update wmjp
			set [description] = rtrim(d.descr)
		from sqlwmj.mojo_prod.dbo.tProject wmjp
		inner join denverapp.dbo.pjProj dslp
			on right(wmjp.projectNumber,11) = dslp.project 
		inner join denverapp.dbo.xIGProdCode d
			on coalesce(dslp.pm_id02,'') = coalesce(d.code_id,'')
		where wmjp.projectKey = @maxProjectKey

		if @@error <> 0
		begin  
		
			set @message = 'Error populating mojo_prod.dbo.tProjec description field.'
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
*/
GO
