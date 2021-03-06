USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRecurTranUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptRecurTranUpdate]
(
	@RecurTranKey int,
	@CompanyKey int,
	@Description varchar(4000),
	@Entity varchar(50),
	@EntityKey int,
	@ReminderOption varchar(50),
	@Frequency varchar(50),
	@NextDate datetime,
	@NumberRemaining int,
	@DaysInAdvance int,
	@Active tinyint,
	@CreateAsApproved tinyint
) --Encrypt

as 

  /*
  || When     Who Rel    What
  || 02/12/10 GWG 10.519 Creation for new recurring logic                      
  || 03/01/10 GHL 10.519 Checking now Entity/EntityKey before inserting record       
  || 11/20/12 GHL 10.562 Added update of revenue forecast                 
  */
  
if @RecurTranKey = 0
BEGIN

	SELECT @RecurTranKey = RecurTranKey
	FROM   tRecurTran (nolock)
	WHERE  Entity = @Entity
	AND    EntityKey = @EntityKey
	
	IF ISNULL(@RecurTranKey, 0) = 0
	BEGIN
		INSERT INTO tRecurTran
			   (CompanyKey
			   ,Description
			   ,Entity
			   ,EntityKey
			   ,ReminderOption
			   ,Frequency
			   ,NextDate
			   ,NumberRemaining
			   ,DaysInAdvance
			   ,Active
			   ,CreateAsApproved)
		 VALUES
			   (@CompanyKey
			   ,@Description
			   ,@Entity
			   ,@EntityKey
			   ,@ReminderOption
			   ,@Frequency
			   ,@NextDate
			   ,@NumberRemaining
			   ,@DaysInAdvance
			   ,@Active
			   ,@CreateAsApproved)
		
		SELECT @RecurTranKey = @@IDENTITY
	END
		
END	
ELSE
BEGIN

	Update tRecurTran
	Set
		CompanyKey = @CompanyKey,
		Description = @Description,
		Entity = @Entity,
		EntityKey = @EntityKey,
		ReminderOption = @ReminderOption,
		Frequency = @Frequency,
		NextDate = @NextDate,
		NumberRemaining = @NumberRemaining,
		DaysInAdvance = @DaysInAdvance,
		Active = @Active,
		CreateAsApproved = @CreateAsApproved
	Where
		RecurTranKey = @RecurTranKey

	if @Entity = 'INVOICE'
	begin
		update tForecastDetail
		set    RegenerateNeeded = 1
		where  Entity = 'tInvoice'
		and    EntityKey = @EntityKey
	end


END


return @RecurTranKey
GO
