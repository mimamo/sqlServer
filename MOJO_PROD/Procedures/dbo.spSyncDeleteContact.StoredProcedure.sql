USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spSyncDeleteContact]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSyncDeleteContact]

	(
		@CompanyKey int,
		@UserKey int
	)

AS --Encrypt

Declare @RetVal int

if @UserKey is not null
BEGIN
	EXEC @RetVal = sptUserDelete @UserKey
	if @RetVal < 0
		Return -1
	
	if not exists(Select 1 from tUser (nolock) Where CompanyKey = @CompanyKey)
	BEGIN
		EXEC @RetVal = sptCompanyDelete @CompanyKey
		if @RetVal < 0 
			Return -1
			
		Return 1
	END
	
	return 1
END
else
BEGIN
EXEC @RetVal = sptCompanyDelete @CompanyKey
	if @RetVal < 0 
		Return -1
		
Return 1
END
GO
