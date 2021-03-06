USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptIssueStatusUpdate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptIssueStatusUpdate]
(
    @ActivityStatusKey int,
    @CompanyKey int,
    @StatusName varchar(500),
    @ActivityTypeKey int,
    @AssignToKey int,
    @IsCompleted tinyint,
    @DisplayOrder int
)

as


if ISNULL(@ActivityStatusKey, 0) > 0
BEGIN

	UPDATE tActivityStatus
	   SET CompanyKey = @CompanyKey
		  ,ActivityTypeKey = @ActivityTypeKey
		  ,StatusName = @StatusName
		  ,AssignToKey = @AssignToKey
		  ,IsCompleted = @IsCompleted
		  ,DisplayOrder = @DisplayOrder
	 WHERE ActivityStatusKey = @ActivityStatusKey

END
ELSE
BEGIN
	INSERT INTO tActivityStatus
           (CompanyKey
           ,ActivityTypeKey
           ,StatusName
           ,AssignToKey
           ,IsCompleted
           ,DisplayOrder)
     VALUES
           (@CompanyKey
           ,@ActivityTypeKey
           ,@StatusName
           ,@AssignToKey
           ,@IsCompleted
           ,@DisplayOrder)


	Select @ActivityStatusKey = @@IDENTITY
END

return @ActivityStatusKey
GO
