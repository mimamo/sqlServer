USE [DENVERAPP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'xWRKMG_intProjectCreate'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[xWRKMG_intProjectCreate]
GO

CREATE PROCEDURE [dbo].[xWRKMG_intProjectCreate]   

     
AS

/*******************************************************************************************************
*   DENVERAPP.dbo.xWRKMG_intProjectCreate 
*
*   Dev Contact: Michelle Morales
*
*   Notes:         
*                  
*
*   Usage:  To use in SSIS Package for Workamajig Integration

        execute DENVERAPP.dbo.xWRKMG_intProjectCreate 
        
        set statistics io on 
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	04/11/2016	Task 34631: Adding PM.
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
DECLARE @RETURN int,
	@JOB_NUMBER varchar(20),
	@JOB_TITLE varchar(255),
	@PARENT_JOB varchar(16),
	@SUB_PROD_CODE varchar(5),
	@SUB_PROD_GROUP varchar(30),
	@CLIENT_ID varchar(15),
	@SUB_TYPE varchar(5), -- DAB - Added 4/25/2012 - this will declare the variable for the sub_type field
	@PM varchar(10)

---------------------------------------------
-- create temp tables
---------------------------------------------
     
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------


DECLARE PROJECT_CURSOR CURSOR 
FOR 
SELECT a.[job_number]
	,a.[job_title]
	,a.[parent_job]
	,a.[sub_prod_code]
	,RTRIM(c.[code_group]) AS sub_prod_group
	,RTRIM(b.[pm_id01]) AS client_id
	,RTRIM(b.[pm_id05]) AS sub_type -- DAB - Added 4/25/2012 - this will get the sub-type field for the project
FROM [xTRAPS_JOBHDR] a
INNER JOIN [PJPROJ] b
	ON a.job_number = b.project
INNER JOIN [xIGProdCode] c
	ON a.sub_prod_code = c.code_ID
WHERE trigger_status = '00'

OPEN PROJECT_CURSOR

-- DAB - Added 4/25/2012 - this add the sub_type variable to the fetch
FETCH NEXT FROM PROJECT_CURSOR INTO @JOB_NUMBER, @JOB_TITLE, @PARENT_JOB, @SUB_PROD_CODE, @SUB_PROD_GROUP, @CLIENT_ID, @SUB_TYPE 

WHILE @@FETCH_STATUS = 0
BEGIN

	BEGIN TRY
	-- DAB - Added 4/25/2012 - this will pass the sub_type field to the Mojo stored procedure
	EXEC @RETURN = [sqlwmj].[Mojo_prod].[dbo].[intProjectCreate] @JOB_NUMBER, @JOB_TITLE, @PARENT_JOB, @SUB_PROD_CODE, @SUB_PROD_GROUP, @CLIENT_ID, @SUB_TYPE

	BEGIN TRANSACTION

		IF @RETURN < 0 
		BEGIN

			UPDATE [xTRAPS_JOBHDR] 
				SET trigger_status = CAST(@RETURN AS varchar(2)) 
			WHERE [job_number] = @JOB_NUMBER

		COMMIT TRANSACTION 

	END
	ELSE 
		BEGIN 

		UPDATE [xTRAPS_JOBHDR] 
			SET trigger_status = 'IM' 
		WHERE [job_number] = @JOB_NUMBER -- completed status used from existing integration from TRAPS
		
		COMMIT TRANSACTION 

		END

	END TRY

BEGIN CATCH 
	-- SELECT ERROR_MESSAGE(), ERROR_NUMBER()
	IF (XACT_STATE())=-1 
		ROLLBACK TRANSACTION 
END CATCH

-- DAB - Added 4/25/2012 - this will roll back any changes that were made. added sub_type to it
FETCH NEXT FROM PROJECT_CURSOR INTO @JOB_NUMBER, @JOB_TITLE, @PARENT_JOB, @SUB_PROD_CODE, @SUB_PROD_GROUP, @CLIENT_ID, @SUB_TYPE
END
CLOSE PROJECT_CURSOR
DEALLOCATE PROJECT_CURSOR




---------------------------------------------
-- permissions
---------------------------------------------
grant execute on xWRKMG_intProjectCreate to BFGROUP
go
