USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10574]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10574]
AS
	SET NOCOUNT ON 

	-- TimeSheetCopy did not update that field
	-- update it now
	update tTime 
	set HCostRate = CostRate


	-- need to set the new CompanyTimeZoneIndex
	-- going to take an admin users timezoneindex as the default
	Declare @CurKey int, @TimeZoneIndex int, @CurUserKey int
	Select @CurKey = -1
	While 1=1
	begin
	 Select @CurKey = Min(CompanyKey) from tCompany (nolock) Where CompanyKey > @CurKey and OwnerCompanyKey is null and TimeZoneIndex is null
	 if @CurKey is null
	  Break
		select @CurUserKey = UserKey from (
			Select  Top 1 UserKey from tUser (nolock) where CompanyKey = @CurKey and Administrator = 1 and Active = 1
		) as data
	
		select @TimeZoneIndex = TimeZoneIndex from tUser (nolock) where UserKey = @CurUserKey
    
		Select @TimeZoneIndex = ISNULL(@TimeZoneIndex, 35)
		update tCompany set TimeZoneIndex = @TimeZoneIndex where CompanyKey = @CurKey 
	end
	
	UPDATE	tWebDavServer
	SET		PreTokenKey = NULL,
			AuthToken = NULL,
			RefreshToken = NULL
	WHERE	Type = 1

	-- default Gross Amount to BillableCost
	update tExpenseReceipt
	set    GrossAmount = BillableCost

	--
	-- Default the rights of ToDos to those of Activities
	--
	 DECLARE @RK INT, @NewRK INT, @RAK INT
	 
	 SELECT @RAK = -1
	 SELECT @RK = RightKey FROM tRight WHERE RightID = 'useActivities'
	 SELECT @NewRK = RightKey FROM tRight WHERE RightID = 'prjViewToDos'
	 
	 IF @NewRK IS NOT NULL
	 BEGIN
		 WHILE (1=1)
		 BEGIN
			SELECT @RAK = MIN(RightAssignedKey)
			  FROM   tRightAssigned
			 WHERE RightKey = @RK
			   AND RightAssignedKey > @RAK
			
			IF @RAK IS NULL
				BREAK
			
			INSERT tRightAssigned (EntityType, EntityKey, RightKey)
			SELECT EntityType, EntityKey, @NewRK
			  FROM tRightAssigned 
			 WHERE RightAssignedKey = @RAK

		 END
	 END
	 --
	 --
	 --
	 SELECT @RAK = -1
	 SELECT @RK = RightKey FROM tRight WHERE RightID = 'viewOtherActivities'
	 SELECT @NewRK = RightKey FROM tRight WHERE RightID = 'prjViewOtherToDos'
	 
	 IF @NewRK IS NOT NULL
	 BEGIN
		 WHILE (1=1)
		 BEGIN
			SELECT @RAK = MIN(RightAssignedKey)
			  FROM   tRightAssigned
			 WHERE RightKey = @RK
			   AND RightAssignedKey > @RAK
			
			IF @RAK IS NULL
				BREAK
			
			INSERT tRightAssigned (EntityType, EntityKey, RightKey)
			SELECT EntityType, EntityKey, @NewRK
			  FROM tRightAssigned 
			 WHERE RightAssignedKey = @RAK

		 END
	 END
	 --
	 --
	 --
	 SELECT @RAK = -1
	 SELECT @RK = RightKey FROM tRight WHERE RightID = 'editActivities'
	 SELECT @NewRK = RightKey FROM tRight WHERE RightID = 'prjEditToDos'
	 
	 IF @NewRK IS NOT NULL
	 BEGIN
		 WHILE (1=1)
		 BEGIN
			SELECT @RAK = MIN(RightAssignedKey)
			  FROM   tRightAssigned
			 WHERE RightKey = @RK
			   AND RightAssignedKey > @RAK
			
			IF @RAK IS NULL
				BREAK
			
			INSERT tRightAssigned (EntityType, EntityKey, RightKey)
			SELECT EntityType, EntityKey, @NewRK
			  FROM tRightAssigned 
			 WHERE RightAssignedKey = @RAK

		 END
	 END
	 --
	 --
	 --
	 SELECT @RAK = -1
	 SELECT @RK = RightKey FROM tRight WHERE RightID = 'editOtherActivities'
	 SELECT @NewRK = RightKey FROM tRight WHERE RightID = 'prjEditOtherToDos'
	 
	 IF @NewRK IS NOT NULL
	 BEGIN
		 WHILE (1=1)
		 BEGIN
			SELECT @RAK = MIN(RightAssignedKey)
			  FROM   tRightAssigned
			 WHERE RightKey = @RK
			   AND RightAssignedKey > @RAK
			
			IF @RAK IS NULL
				BREAK
			
			INSERT tRightAssigned (EntityType, EntityKey, RightKey)
			SELECT EntityType, EntityKey, @NewRK
			  FROM tRightAssigned 
			 WHERE RightAssignedKey = @RAK

		 END
	 END
	 --
	 --
	 --
	 SELECT @RAK = -1
	 SELECT @RK = RightKey FROM tRight WHERE RightID = 'deleteActivities'
	 SELECT @NewRK = RightKey FROM tRight WHERE RightID = 'prjDeleteToDos'
	 
	 IF @NewRK IS NOT NULL
	 BEGIN
		 WHILE (1=1)
		 BEGIN
			SELECT @RAK = MIN(RightAssignedKey)
			  FROM   tRightAssigned
			 WHERE RightKey = @RK
			   AND RightAssignedKey > @RAK
			
			IF @RAK IS NULL
				BREAK
			
			INSERT tRightAssigned (EntityType, EntityKey, RightKey)
			SELECT EntityType, EntityKey, @NewRK
			  FROM tRightAssigned 
			 WHERE RightAssignedKey = @RAK

		 END
	 END
	 
	RETURN
GO
