USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSpecSheetInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSpecSheetInsert]
	@Entity VARCHAR(50),
	@EntityKey INT,
	@FieldSetKey INT,
	@CustomFieldKey INT,
	@Subject VARCHAR(200),
	@Description TEXT,
	@UserKey INT,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel      What
|| 05/2/12   RLB 10.5.5.5 (124424) Changed Description to a Text field
|| 04/21/15  WDF 10.5.9.1 (250962) Added @UserKey; CreatedByKey/CreatedByDate
|| 04/27/15  KMC 10.5.9.1 (248283) Added insert into tActionLog
*/

DECLARE @DisplayOrder INT
DECLARE @Date SMALLDATETIME, @Comment VARCHAR(4000), @Reference VARCHAR(200), @ProjectKey INT = NULL

	SELECT @DisplayOrder = Count(*) FROM tSpecSheet (NOLOCK) WHERE Entity = @Entity AND EntityKey = @EntityKey
	SELECT @DisplayOrder = ISNULL(@DisplayOrder, 0) + 1
	
	INSERT tSpecSheet
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
	
	SELECT @oIdentity = @@IDENTITY

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
	SELECT @Comment = 'Spec Sheet Inserted - ' + @Subject
	EXEC sptActionLogInsert 'Spec Sheets', @oIdentity, 0, @ProjectKey, 'Spec Sheet Inserted',
                        @Date, NULL, @Comment, @Reference, NULL, @UserKey

	RETURN 1
GO
