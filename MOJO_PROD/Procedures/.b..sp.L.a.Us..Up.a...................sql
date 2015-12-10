USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadUserUpdate]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadUserUpdate]
	(
	@LeadKey int,
	@UserKey int,
	@Role varchar(300),
	@Action varchar(20)
	)

AS

  /*
  || When     Who Rel      What
  || 01/14/09 GHL 10.5	We need to update WWPCurrentLevel when assigning users
  ||                    Needs to be done in 2 places sptLeadUpdate and here
  ||                    because the lead user lists are not updated when the lead record changes 
  */
  
Declare @CompanyKey int, @CurLevel int, @MaxLevel int
  
-- Get the current level for the user
Select @CurLevel = ISNULL(WWPCurrentLevel, 0)
		,@CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) 
from tUser (nolock) Where UserKey = @UserKey 
    
-- then insert/delete the links to the lead    
if @Action = 'update'
BEGIN

	if exists(Select 1 from tLeadUser (nolock) Where LeadKey = @LeadKey and UserKey = @UserKey)
		Update tLeadUser
			Set Role = @Role
			Where LeadKey = @LeadKey and UserKey = @UserKey
	else
		Insert tLeadUser (LeadKey, UserKey, Role)
		Values (@LeadKey, @UserKey, @Role)

END
ELSE
BEGIN

	Delete tLeadUser Where LeadKey = @LeadKey and UserKey = @UserKey
END

-- now calculate the max level
Select @MaxLevel = MAX(WWPCurrentLevel) 
from tLead l (nolock)
inner join tLeadUser lu on l.LeadKey = lu.LeadKey
Where lu.UserKey = @UserKey and 
(LeadOutcomeKey is null OR 
LeadOutcomeKey in (Select LeadOutcomeKey 
					from tLeadOutcome (nolock) 
					Where CompanyKey = @CompanyKey and PositiveOutcome = 1))


-- and update the user record
if @CurLevel <> ISNULL(@MaxLevel, 0)
BEGIN
	Update tUser Set WWPCurrentLevel = @MaxLevel Where UserKey = @UserKey
	
	Insert tLevelHistory (Entity, EntityKey, Level, Status, LevelDate)
	Values ('tUser', @UserKey, @MaxLevel, NULL, GETUTCDATE())
END
GO
