USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLaborBudgetGenerate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLaborBudgetGenerate]

	(
		@LaborBudgetKey int,
		@AvailableHours int,
		@TargetHours int
	)

AS --Encrypt

  /*
  || When     Who Rel         What
  || 04/16/08 GHL 8.508      (24869)Limiting now to active users only
  */

Declare @CompanyKey int

Select @CompanyKey = CompanyKey from tLaborBudget (nolock) Where LaborBudgetKey = @LaborBudgetKey

INSERT tLaborBudgetDetail
		(
		LaborBudgetKey,
		UserKey,
		Locked,
		AvailableHours1,
		TargetHours1,
		TargetDollars1,
		AvailableHours2,
		TargetHours2,
		TargetDollars2,
		AvailableHours3,
		TargetHours3,
		TargetDollars3,
		AvailableHours4,
		TargetHours4,
		TargetDollars4,
		AvailableHours5,
		TargetHours5,
		TargetDollars5,
		AvailableHours6,
		TargetHours6,
		TargetDollars6,
		AvailableHours7,
		TargetHours7,
		TargetDollars7,
		AvailableHours8,
		TargetHours8,
		TargetDollars8,
		AvailableHours9,
		TargetHours9,
		TargetDollars9,
		AvailableHours10,
		TargetHours10,
		TargetDollars10,
		AvailableHours11,
		TargetHours11,
		TargetDollars11,
		AvailableHours12,
		TargetHours12,
		TargetDollars12
		)
	Select
		@LaborBudgetKey,
		UserKey,
		0,
		@AvailableHours,
		@TargetHours,
		@TargetHours * ISNULL(HourlyRate, 0),
		@AvailableHours,
		@TargetHours,
		@TargetHours * ISNULL(HourlyRate, 0),
		@AvailableHours,
		@TargetHours,
		@TargetHours * ISNULL(HourlyRate, 0),
		@AvailableHours,
		@TargetHours,
		@TargetHours * ISNULL(HourlyRate, 0),
		@AvailableHours,
		@TargetHours,
		@TargetHours * ISNULL(HourlyRate, 0),
		@AvailableHours,
		@TargetHours,
		@TargetHours * ISNULL(HourlyRate, 0),
		@AvailableHours,
		@TargetHours,
		@TargetHours * ISNULL(HourlyRate, 0),
		@AvailableHours,
		@TargetHours,
		@TargetHours * ISNULL(HourlyRate, 0),
		@AvailableHours,
		@TargetHours,
		@TargetHours * ISNULL(HourlyRate, 0),
		@AvailableHours,
		@TargetHours,
		@TargetHours * ISNULL(HourlyRate, 0),
		@AvailableHours,
		@TargetHours,
		@TargetHours * ISNULL(HourlyRate, 0),
		@AvailableHours,
		@TargetHours,
		@TargetHours * ISNULL(HourlyRate, 0)
	From tUser (nolock) 
	Where CompanyKey = @CompanyKey
	And   Active = 1
GO
