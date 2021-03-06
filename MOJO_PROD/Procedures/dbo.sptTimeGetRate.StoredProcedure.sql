USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeGetRate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTimeGetRate]
 @UserKey int,
 @ProjectKey int,
 @TaskKey int,
 @ServiceKey int,
 @RateLevel int,
 @CheckTimeActive tinyint = 0,
 @oHourlyRate money output
 
AS --Encrypt

/*
|| When      Who Rel	   What
|| 06/03/09  GHL 10.0.2.6  This SP is now the unique point to determine the labor rate
||                         Added parameter CheckTimeActive so that it can be called:
||                         - with CheckTimeActive = 0 for billing screens
||                         - with CheckTimeActive = 1 for time entry screens
|| 08/17/11  GWG 10.5.4.7  Default failback hourly rate to 0
|| 09/24/14  MAS 10.5.8.4  Added Billing Title(9) and Billing Title Rate Sheet(10) for Abelson & Taylor
|| 09/30/14  GHL 10.5.8.4  Fixed situation where a title is created and assigned to a user
||                         but the tTitleRateSheetDetail is still missing
||                         if that is the case try the HourlyRate from the title (by Greg)
||                         Also match tTitleRateSheetDetail on both TitleRateSheetKey and TitleKey
|| 01/20/15 RLB 10.5.8.8   (243021) Like Title Ratesheet service ratesheet will pull the service rate if nothing is on ratesheet
|| 02/09/15 GHL 10.5.8.9   Do not return -9 and -10 for titles because they are already used by sptTimeInsert and sptTimeUpdateGrid
||                         and other SPs so return -309 and -310 instead
|| 02/10/15 GHL 10.5.8.9   If the project requires a title and the user does not have a title error out with -311 (abelson taylor)
*/


DECLARE @ActualRate money,
   @GetRateFrom smallint,
   @OverrideRate tinyint,
   @CompanyKey int,
   @TimeKey uniqueidentifier,
   @TimeRateSheetKey int,
   @TitleRateSheetKey int,
   @RateSheetRate money,
   @UseTasks smallint,
   @CostRate money,
   @ProjectStatusKey int
 
IF @ProjectKey IS NULL
BEGIN
    SELECT @ActualRate = Case @RateLevel 
	When 1 then HourlyRate1
	When 2 then HourlyRate2
	When 3 then HourlyRate3
	When 4 then HourlyRate4
	When 5 then HourlyRate5
	else HourlyRate1 END
  FROM tService (NOLOCK)
  WHERE ServiceKey = @ServiceKey
  
  IF @ActualRate IS NULL
   --Get it From the User
   SELECT @ActualRate = ISNULL(HourlyRate, 0)
   FROM tUser (NOLOCK)
   WHERE UserKey = @UserKey
   
   IF @ActualRate IS NULL
    RETURN -100 --No project specified and no rate for Service, or Service not specified, and no rate for User
END
ELSE
BEGIN
  -- ProjectKey is not null
   
  SELECT @GetRateFrom = GetRateFrom, @OverrideRate = OverrideRate
  , @CompanyKey = ClientKey, @TimeRateSheetKey = TimeRateSheetKey, @ProjectStatusKey = ProjectStatusKey 
  , @TitleRateSheetKey = TitleRateSheetKey 
  FROM tProject (NOLOCK)
  WHERE ProjectKey = @ProjectKey
  
  IF @CheckTimeActive = 1
  BEGIN
      IF NOT EXISTS (SELECT 1 FROM tProjectStatus (NOLOCK) 
		WHERE ProjectStatusKey = @ProjectStatusKey AND TimeActive = 1)
        RETURN -9
  END
  
  -- Same check as in sptTimeInsert
  IF NOT @GetRateFrom IN (1,2,3,4,5,6,7,8,9,10)
     RETURN -11
      
  IF @GetRateFrom = 5 AND @TimeRateSheetKey IS NULL
   RETURN -5  -- No rate sheet key for this project.

  IF @GetRateFrom = 8 AND @TimeRateSheetKey IS NULL
   RETURN -8  -- No rate sheet key for this project.
   
  IF @GetRateFrom = 10 AND @TitleRateSheetKey IS NULL
   RETURN -310  -- No title rate sheet key for this project.

  IF @GetRateFrom in (9, 10)
  BEGIN
	IF NOT EXISTS (SELECT 1 FROM tUser (NOLOCK) WHERE UserKey = @UserKey and ISNULL(TitleKey, 0) > 0)
		RETURN -311 -- No title for this user
  END
  
  IF @OverrideRate = 1
  BEGIN
		SELECT @ActualRate = ISNULL(Case @RateLevel 
			When 1 then HourlyRate1
			When 2 then HourlyRate2
			When 3 then HourlyRate3
			When 4 then HourlyRate4
			When 5 then HourlyRate5
			else HourlyRate1 END, 0)
		FROM tService (NOLOCK)
		WHERE ServiceKey = @ServiceKey

		IF @ActualRate > 0
			SELECT @ActualRate = NULL
   END
	
  IF (@ActualRate IS NULL) OR (@ActualRate != 0)
	IF @GetRateFrom = 1 --Client
		SELECT @ActualRate = HourlyRate
		FROM tCompany (NOLOCK)
		WHERE CompanyKey = @CompanyKey

	ELSE IF @GetRateFrom = 2 --Project
		SELECT @ActualRate = HourlyRate
		FROM tProject (NOLOCK)
		WHERE ProjectKey = @ProjectKey
	
	ELSE IF @GetRateFrom = 3 --Project/User
		SELECT @ActualRate = HourlyRate
		FROM tAssignment (NOLOCK)
		WHERE ProjectKey = @ProjectKey
		AND  UserKey = @UserKey
			
	ELSE IF @GetRateFrom = 4 --Service
		SELECT @ActualRate = Case @RateLevel 
				When 1 then HourlyRate1
				When 2 then HourlyRate2
				When 3 then HourlyRate3
				When 4 then HourlyRate4
				When 5 then HourlyRate5
				else HourlyRate1 END
		FROM tService (NOLOCK)
		WHERE ServiceKey = @ServiceKey
				
	ELSE IF @GetRateFrom = 5 -- Rate Sheet
	BEGIN
		SELECT @ActualRate = Case @RateLevel 
				When 1 then HourlyRate1
				When 2 then HourlyRate2
				When 3 then HourlyRate3
				When 4 then HourlyRate4
				When 5 then HourlyRate5
				else HourlyRate1 END
		FROM tTimeRateSheetDetail (NOLOCK)
		WHERE ServiceKey = @ServiceKey AND
		  TimeRateSheetKey = @TimeRateSheetKey
		-- If there is no rate on ratesheet use rate on the service
		IF @ActualRate IS NULL
			SELECT @ActualRate = Case @RateLevel 
				When 1 then HourlyRate1
				When 2 then HourlyRate2
				When 3 then HourlyRate3
				When 4 then HourlyRate4
				When 5 then HourlyRate5
				else HourlyRate1 END
			FROM tService (NOLOCK)
			WHERE ServiceKey = @ServiceKey
	END
	ELSE IF @GetRateFrom = 6 -- Task
		SELECT @ActualRate = HourlyRate
		FROM   tTask (NOLOCK)
		WHERE  TaskKey = @TaskKey
		
	ELSE IF @GetRateFrom = 7 -- Service on Task
		SELECT @ActualRate = Case @RateLevel 
			When 1 then s.HourlyRate1
			When 2 then s.HourlyRate2
			When 3 then s.HourlyRate3
			When 4 then s.HourlyRate4
			When 5 then s.HourlyRate5
			else s.HourlyRate1 END
		FROM   tTask    t (NOLOCK)
		      ,tService s (NOLOCK)
		WHERE  t.TaskKey = @TaskKey
		AND    t.ServiceKey = s.ServiceKey

	ELSE IF @GetRateFrom = 9 --(User's)Billing Title
		SELECT @ActualRate = t.HourlyRate -- If Null, will fail correctly below
		FROM tTitle t (NOLOCK)
		INNER JOIN tUser u (NOLOCK) on u.TitleKey = t.TitleKey
		WHERE u.UserKey = @UserKey
				
	ELSE IF @GetRateFrom = 10 --Billing Title Rate Sheet
	BEGIN
		-- careful with situations where a title is created and assigned to a user
		-- but the tTitleRateSheetDetail is still missing
		-- if that is the case try the HourlyRate from the title (by Greg)

		declare @TitleKey int, @TitleHourlyRate money 

		select @TitleKey = t.TitleKey
              ,@TitleHourlyRate = t.HourlyRate -- leave null, will fail correctly below
		from   tUser u (nolock)
			left outer join tTitle t (nolock) on u.TitleKey = t.TitleKey
		where  u.UserKey = @UserKey 

		SELECT @ActualRate = HourlyRate
		FROM   tTitleRateSheetDetail (NOLOCK)  
		WHERE  TitleRateSheetKey = @TitleRateSheetKey	
		AND    TitleKey = @TitleKey
	
		-- if missing in the database, try to get it from the Title
		if @ActualRate is null
			select @ActualRate = @TitleHourlyRate
	END	  		
	ELSE
		-- 8 / Rate Sheet/Get Service from task
		SELECT @ActualRate = Case @RateLevel 
			When 1 then trsd.HourlyRate1
			When 2 then trsd.HourlyRate2
			When 3 then trsd.HourlyRate3
			When 4 then trsd.HourlyRate4
			When 5 then trsd.HourlyRate5
			else trsd.HourlyRate1 END
		FROM   tTask    t (NOLOCK)
		      ,tService s (NOLOCK)
		      ,tTimeRateSheetDetail trsd (NOLOCK)
		WHERE  t.TaskKey = @TaskKey
		AND    t.ServiceKey = s.ServiceKey
		AND    s.ServiceKey = trsd.ServiceKey
		AND    trsd.TimeRateSheetKey = @TimeRateSheetKey
		
  IF @ActualRate IS NULL
  begin
	if @GetRateFrom not in (9, 10)
		RETURN -@GetRateFrom --This will tell you which rate it was looking for
	else
		-- add -300 so that it does not conflict with other current error returns
		-- it is safe to set the errors below -300
		RETURN -@GetRateFrom - 300  
  end
   
 END -- ProjectKey is not null
 
 Select @oHourlyRate = @ActualRate
 
 
return 1
GO
