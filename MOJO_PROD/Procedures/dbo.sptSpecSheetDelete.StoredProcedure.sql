USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSpecSheetDelete]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSpecSheetDelete]
	@SpecSheetKey INT,
	@UserKey INT = NULL

AS --Encrypt

/*
|| When     Who Rel      What
|| 04/27/15 KMC 10.5.9.1 (248283) Added @UserKey param and insert into tActionLog
*/

DECLARE @CustomFieldKey INT, @Entity VARCHAR(50), @EntityKey INT, @Subject VARCHAR(200)
DECLARE @Date SMALLDATETIME, @Comment VARCHAR(4000), @Reference VARCHAR(200), @ProjectKey INT = NULL

	SELECT @CustomFieldKey = ISNULL(CustomFieldKey, 0), @Entity = ISNULL(Entity, ''), @EntityKey = ISNULL(EntityKey, 0), @Subject = ISNULL(Subject, 0)
	FROM tSpecSheet (NOLOCK)
	WHERE
		SpecSheetKey = @SpecSheetKey 
		
	IF @CustomFieldKey > 0 
	BEGIN
		EXEC spCF_tObjectFieldSetDelete @CustomFieldKey
	END
	
	DELETE
	FROM tSpecSheet
	WHERE
		SpecSheetKey = @SpecSheetKey

	--Get supporting fields for tActionLog insert
	IF @Entity = 'Project'
	BEGIN
		SELECT @Reference = ISNULL(ProjectNumber, '') + '  -  ' + ISNULL(ProjectName, ''), @ProjectKey = ProjectKey 
		  FROM tProject (NOLOCK) 
		 WHERE ProjectKey = @EntityKey
	END
	ELSE
	BEGIN
		IF @Entity = 'ProjectRequest'
		BEGIN
			SELECT @Reference = ISNULL(RequestID, '') + '  -  ' + ISNULL(Subject, '') 
			  FROM tRequest (NOLOCK) 
			 WHERE RequestKey = @EntityKey
		END
		ELSE
		BEGIN
			IF @Entity = 'Lead'
			BEGIN
				SELECT @Reference = Subject 
				  FROM tLead (NOLOCK) 
				 WHERE LeadKey = @EntityKey
			END
		END
	END

	SELECT @Date = GETDATE()
	SELECT @ProjectKey = ISNULL(@ProjectKey, 0)
	SELECT @Comment = 'Spec Sheet Delete - ' + @Subject
	EXEC sptActionLogInsert 'Spec Sheets', @SpecSheetKey, 0, @ProjectKey, 'Spec Sheet Deleted',
                        @Date, NULL, @Comment, @Reference, NULL, @UserKey

	RETURN 1
GO
