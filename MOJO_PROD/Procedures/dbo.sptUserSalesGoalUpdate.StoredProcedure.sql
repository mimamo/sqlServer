USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserSalesGoalUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserSalesGoalUpdate]

	@GoalKey int,
	@EntityKey int,
	@Entity varchar(50),
	@Year int,
	@Total money,
	@Month1 money,
	@Month2 money,
	@Month3 money,
	@Month4 money,
	@Month5 money,
	@Month6 money,
	@Month7 money,
	@Month8 money,
	@Month9 money,
	@Month10 money,
	@Month11 money,
	@Month12 money


AS --Encrypt
/*
|| When      Who Rel      What
|| 12/19/14  RLB 10.5.8.7 Created for New Sales Goals
*/

IF @GoalKey <=0
	BEGIN
		INSERT tGoal
			(
			EntityKey,
			Entity,
			Year,
			Total,
			Month1,
			Month2,
			Month3,
			Month4,
			Month5,
			Month6,
			Month7,
			Month8,
			Month9,
			Month10,
			Month11,
			Month12
			)
		VALUES
			(
			@EntityKey,
			@Entity,
			@Year,
			@Total,
			@Month1,
			@Month2,
			@Month3,
			@Month4,
			@Month5,
			@Month6,
			@Month7,
			@Month8,
			@Month9,
			@Month10,
			@Month11,
			@Month12
			)
		
		RETURN @@IDENTITY

	END
ELSE
	BEGIN
		UPDATE
			tGoal
		SET
			EntityKey = @EntityKey,
			Entity = @Entity,
			Year = @Year,
			Total = @Total,
			Month1 = @Month1,
			Month2 = @Month2,
			Month3 = @Month3,
			Month4 = @Month4,
			Month5 = @Month5,
			Month6 = @Month6,
			Month7 = @Month7,
			Month8 = @Month8,
			Month9 = @Month9,
			Month10 = @Month10,
			Month11 = @Month11,
			Month12 = @Month12
		WHERE
			GoalKey = @GoalKey 

		RETURN @GoalKey 
	END
GO
