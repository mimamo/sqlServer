USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xAlt_PostTimesheetDirectly]    Script Date: 12/21/2015 14:06:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xAlt_PostTimesheetDirectly] @DocNbr varchar(15), @LineNbr int, @PerPost varchar(10)

AS

DECLARE @RateSource varchar(1)
SET @RateSource = 'S'
DECLARE @ControlData varchar(255)

DECLARE @Pay_Type varchar(2), 
		@HrsTot float, 
		@Factor varchar(5), 
		@Employee varchar(15), 
		@Project varchar(15), 
		@LineDate smalldatetime,
		@HourlyRate float,
		@SalaryRate float,
		@GLAcct varchar(15),
		@Account_Category varchar(30),
		@TimeSheet_ID18 float,
		@CertPaySW varchar(10),
		@RegHours float,
		@OT1Hours float,
		@OT2Hours float
		


SET @Factor = '1.00'
SELECT
	@HrsTot = reg_hours + ot1_hours + ot2_hours,
	@employee = employee,
	@Project = Project,
	@LineDate = tl_date,
	@GLAcct = gl_acct,
	@TimeSheet_ID18 = tl_id18,
	@CertPaySW = cert_pay_sw,
	@RegHours = reg_hours,
	@OT1Hours = OT1_Hours,
	@OT2Hours = OT2_Hours
FROM
	PJTIMDET
WHERE
	DocNbr = @DocNbr AND
	LineNbr = @LineNbr

DECLARE @Paytype varchar(30)
SELECT @PayType = ep_id05, @HourlyRate = Labor_rate, @SalaryRate = Labor_Rate 
FROM PJEMPPJT
WHERE employee  = @Employee and
	  project like 'na' and    
	  effect_date <=  @LineDate

select @Account_Category = acct  from pj_account where gl_acct = @GLAcct 

IF @TimeSheet_ID18 > 0
	BEGIN
	PRINT 'Test'
	--Post Labor Cost
	END

DECLARE @PrevWageRate float

If @PayType IN ('HR', 'S1', 'S2')
	BEGIN
		IF @CertPaySW = 'N'
			BEGIN
				SET @CertPaySW = '0'
			END
		ELSE
			BEGIN
				SET @CertPaySW = '1'
			END
	
	
		--Need to get prevailing wage rate, but not for INteger Denver, not used

		SET @PrevWageRate = -1


		-- get info from Rate Options record
		DECLARE @RateLookupMethod varchar(1),
				@LaborRateType varchar(2),
				@CostLaborWhen varchar(1)
		SELECT @ControlData = Control_data FROM PJCONTRL WHERE control_type = 'TM' AND control_code = 'RATE-OPTIONS'
		SET @RateLookupMethod = SUBSTRING(@ControlData, 1, 1)
		SET @LaborRateType = SUBSTRING(@ControlData, 2, 2)
		SET @CostLaborWhen = SUBSTRING(@ControlData, 4, 1)

		DECLARE @Rate_Source varchar(10)
		IF @CostLaborWhen = 'E'
			BEGIN
				SELECT @HourlyRate = Labor_Rate, @RateSource = tl_id16 FROM PJTIMDET WHERE docnbr = @DocNbr AND LineNbr = @LineNbr
			END
		ELSE
			BEGIN
				SELECT @HourlyRate = labor_rate FROM pjemppjt WHERE employee = @Employee and Project = 'na' AND effect_date <= @LineDate
			END


		DECLARE @amount float, @units float
		SET @Amount = @RegHours * @HourlyRate

		IF @RegHours <> 0 
			BEGIN

				EXEC xAlt_TimesheetLaborDistribution 
						@DocNbr, 
						@LineNbr, 
					    @RegHours, 
						@Amount, 
						'REG', 
						@PerPost

				EXEC xAddTransaction_Labor 
						@DocNbr,	-- From PJTimHdr.DocNbr
						@LineNbr,			-- From PJTimDet.LineNbr
						@Account_Category,
						@GLAcct ,
						@PerPost,
						@amount ,
						@RegHours
				END

		SET @Amount = @OT1Hours * @HourlyRate
				
		IF @OT1Hours <> 0
			BEGIN
				EXEC xAlt_TimesheetLaborDistribution 
						@DocNbr, 
						@LineNbr, 
					    @OT1Hours, 
						@Amount, 
						'OT1', 
						@PerPost

				EXEC xAddTransaction_Labor 
						@DocNbr,	-- From PJTimHdr.DocNbr
						@LineNbr,			-- From PJTimDet.LineNbr
						@Account_Category,
						@GLAcct ,
						@PerPost,
						@amount ,
						@OT1Hours
			END 
		SET @Amount = @OT2Hours * @HourlyRate
		
		IF @OT2Hours <> 0
			BEGIN
				EXEC xAlt_TimesheetLaborDistribution 
						@DocNbr, 
						@LineNbr, 
					    @OT2Hours, 
						@Amount, 
						'OT2', 
						@PerPost

				EXEC xAddTransaction_Labor 
						@DocNbr,	-- From PJTimHdr.DocNbr
						@LineNbr,			-- From PJTimDet.LineNbr
						@Account_Category,
						@GLAcct ,
						@PerPost,
						@amount ,
						@OT2Hours
			END
	
	END
GO
