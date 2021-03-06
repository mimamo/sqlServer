USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLaborBudgetDetailUserUpdate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLaborBudgetDetailUserUpdate]
	@LaborBudgetDetailKey int,
	@UserReviewed tinyint,
	@UserComments varchar(4000),
	@AvailableHours1 int,
	@TargetHours1 int,
	@TargetDollars1 money,
	@AvailableHours2 int,
	@TargetHours2 int,
	@TargetDollars2 money,
	@AvailableHours3 int,
	@TargetHours3 int,
	@TargetDollars3 money,
	@AvailableHours4 int,
	@TargetHours4 int,
	@TargetDollars4 money,
	@AvailableHours5 int,
	@TargetHours5 int,
	@TargetDollars5 money,
	@AvailableHours6 int,
	@TargetHours6 int,
	@TargetDollars6 money,
	@AvailableHours7 int,
	@TargetHours7 int,
	@TargetDollars7 money,
	@AvailableHours8 int,
	@TargetHours8 int,
	@TargetDollars8 money,
	@AvailableHours9 int,
	@TargetHours9 int,
	@TargetDollars9 money,
	@AvailableHours10 int,
	@TargetHours10 int,
	@TargetDollars10 money,
	@AvailableHours11 int,
	@TargetHours11 int,
	@TargetDollars11 money,
	@AvailableHours12 int,
	@TargetHours12 int,
	@TargetDollars12 money

AS --Encrypt

	UPDATE
		tLaborBudgetDetail
	SET
		UserReviewed = @UserReviewed,
		UserComments = @UserComments,
		AvailableHours1 = @AvailableHours1,
		TargetHours1 = @TargetHours1,
		TargetDollars1 = @TargetDollars1,
		AvailableHours2 = @AvailableHours2,
		TargetHours2 = @TargetHours2,
		TargetDollars2 = @TargetDollars2,
		AvailableHours3 = @AvailableHours3,
		TargetHours3 = @TargetHours3,
		TargetDollars3 = @TargetDollars3,
		AvailableHours4 = @AvailableHours4,
		TargetHours4 = @TargetHours4,
		TargetDollars4 = @TargetDollars4,
		AvailableHours5 = @AvailableHours5,
		TargetHours5 = @TargetHours5,
		TargetDollars5 = @TargetDollars5,
		AvailableHours6 = @AvailableHours6,
		TargetHours6 = @TargetHours6,
		TargetDollars6 = @TargetDollars6,
		AvailableHours7 = @AvailableHours7,
		TargetHours7 = @TargetHours7,
		TargetDollars7 = @TargetDollars7,
		AvailableHours8 = @AvailableHours8,
		TargetHours8 = @TargetHours8,
		TargetDollars8 = @TargetDollars8,
		AvailableHours9 = @AvailableHours9,
		TargetHours9 = @TargetHours9,
		TargetDollars9 = @TargetDollars9,
		AvailableHours10 = @AvailableHours10,
		TargetHours10 = @TargetHours10,
		TargetDollars10 = @TargetDollars10,
		AvailableHours11 = @AvailableHours11,
		TargetHours11 = @TargetHours11,
		TargetDollars11 = @TargetDollars11,
		AvailableHours12 = @AvailableHours12,
		TargetHours12 = @TargetHours12,
		TargetDollars12 = @TargetDollars12
	WHERE
		LaborBudgetDetailKey = @LaborBudgetDetailKey 

	RETURN 1
GO
