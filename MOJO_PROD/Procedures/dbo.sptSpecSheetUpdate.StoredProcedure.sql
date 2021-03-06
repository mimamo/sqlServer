USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSpecSheetUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSpecSheetUpdate]
	@SpecSheetKey int,
	@Subject varchar(200),
	@Description text,
	@UserKey int,
	@Entity varchar(50) = NULL,
	@EntityKey int = NULL,
	@FieldSetKey int = NULL,
	@CustomFieldKey int = NULL	

AS --Encrypt

/*
|| When      Who Rel      What
|| 05/02/12  RLB 10.5.5.5 (124424) Changed Description to a Text field
|| 05/07/13  MFT 10.5.6.8 Added support for Inserts
|| 03/04/14  GWG 10.5.7.7 Added support for clearing the read flag
|| 09/05/14  GWG 10.5.8.3 Added setting it read for the person entering it
|| 04/21/15  WDF 10.5.9.1 (250962) Added CreatedByKey, CreatedByDate, UpdatedByKey, DateUpdated
|| 04/27/15  KMC 10.5.9.1 (248283) Added insert into tActionLog
*/

DECLARE @Action varchar(200), @Date SMALLDATETIME, @Comment VARCHAR(4000), @Reference VARCHAR(200), @ProjectKey INT = NULL

IF ISNULL(@SpecSheetKey, 0) > 0
BEGIN
	SELECT @Action = 'Spec Sheet Updated'
	SELECT @Comment = 'Spec Sheet Updated - ' + @Subject
	
	UPDATE
		tSpecSheet
	SET
		Subject = @Subject,
		Description = @Description,
		UpdatedByKey = @UserKey,
		DateUpdated	= GETUTCDATE()	

	WHERE
		SpecSheetKey = @SpecSheetKey 
		
	exec sptAppReadClearRead @UserKey, 'tSpecSheet', @SpecSheetKey
END	
ELSE
	BEGIN
		DECLARE @DisplayOrder int
		SELECT @DisplayOrder = COUNT(*) FROM tSpecSheet (nolock) WHERE Entity = @Entity and EntityKey = @EntityKey
		SELECT @DisplayOrder = ISNULL(@DisplayOrder, 0) + 1
		
		SELECT @Action = 'Spec Sheet Inserted'
		SELECT @Comment = 'Spec Sheet Inserted - ' + @Subject
		
		INSERT INTO tSpecSheet
		(
			Entity,
			EntityKey,
			FieldSetKey,
			CustomFieldKey,
			Subject,
			Description,
			DisplayOrder,
			CreatedByKey,
			CreatedByDate	
		)
		VALUES
		(
			@Entity,
			@EntityKey,
			@FieldSetKey,
			@CustomFieldKey,
			@Subject,
			@Description,
			@DisplayOrder,
			@UserKey,
			GETUTCDATE()
		)
		
		SELECT @SpecSheetKey = SCOPE_IDENTITY()
		
		exec sptAppReadMarkRead @UserKey, 'tSpecSheet', @SpecSheetKey
		
	END

	--Get supporting fields for tActionLog insert
	SELECT @Entity = ISNULL(Entity, ''), @EntityKey = ISNULL(EntityKey, 0)
	  FROM tSpecSheet (NOLOCK)
	 WHERE SpecSheetKey = @SpecSheetKey 
	
	IF @Entity = 'Project'
	BEGIN
		SELECT @Reference = + ISNULL(ProjectNumber, '') + '  -  ' + ISNULL(ProjectName, ''), @ProjectKey = ProjectKey 
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
	EXEC sptActionLogInsert 'Spec Sheets', @SpecSheetKey, 0, @ProjectKey, @Action,
                        @Date, NULL, @Comment, @Reference, NULL, @UserKey

RETURN @SpecSheetKey
GO
