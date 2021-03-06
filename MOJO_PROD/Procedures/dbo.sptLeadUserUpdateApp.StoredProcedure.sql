USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadUserUpdateApp]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadUserUpdateApp]
	(
	@LeadUserKey int,
	@LeadKey int,
	@UserKey int,
	@Role varchar(300)
	)

AS

  /*
  || When     Who Rel       What
  || 03/12/15 MAS 10.5.8.9	Created for platinum
  */
  
Declare @CompanyKey int, @CurLevel int, @MaxLevel int, @RetVal int
  
-- Get the current level for the user
Select @CurLevel = ISNULL(WWPCurrentLevel, 0)
		,@CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) 
from tUser (nolock) Where UserKey = @UserKey 

-- check for duplicates & return an error
if exists(Select 1 from tLeadUser (nolock) Where LeadKey = @LeadKey AND UserKey = @UserKey AND LeadUserKey <> @LeadUserKey)
	Return -1
    
-- then insert 
if exists(Select 1 from tLeadUser (nolock) Where LeadUserKey = @LeadUserKey)
  begin
	Update tLeadUser
	Set Role = @Role
	Where LeadUserKey = @LeadUserKey
  end
else
  begin
	Insert tLeadUser (LeadKey, UserKey, Role) Values (@LeadKey, @UserKey, @Role)
	
	Select @LeadUserKey = @@IDENTITY
  end


-- now calculate the max level
Select @MaxLevel = MAX(WWPCurrentLevel) 
from tLead l (nolock)
Inner Join tLeadUser lu on l.LeadKey = lu.LeadKey
Where lu.UserKey = @UserKey 
And (LeadOutcomeKey is null 
Or LeadOutcomeKey in (Select LeadOutcomeKey 
					  from tLeadOutcome (nolock) 
					  Where CompanyKey = @CompanyKey and PositiveOutcome = 1))


-- and update the user record
if @CurLevel <> ISNULL(@MaxLevel, 0)
Begin
	Update tUser Set WWPCurrentLevel = @MaxLevel Where UserKey = @UserKey
	
	Insert tLevelHistory (Entity, EntityKey, Level, Status, LevelDate)
	Values ('tUser', @UserKey, @MaxLevel, NULL, GETUTCDATE())
End

Return @LeadUserKey
GO
