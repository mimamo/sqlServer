USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingFixedFeeInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingFixedFeeInsert]
	@BillingKey int,
	@Entity varchar(50),
	@EntityKey int,
	@Percentage decimal(24,4),
	@Amount money,
	@DepartmentKey int -- this is the default
AS --Encrypt

  /*
  || When     Who Rel   What
  || 04/25/07 GHL 8.5   Getting now Taxable fields when by billing item  
  || 07/09/07 GHL 8.5   Added dept parameter + logic    
  || 07/10/07 QMD 8.5   Expense Type reference changed to tItem      
  || 09/15/09 GHL 10.510 (61782) Getting now DepartmentKey from tWorkType 
  || 07/30/14 GHL 10.582 (224416) We need to save now the DepartmentKey in tBillingFixedFee.DefaultDepartmentKey  
  ||                     because when billing by item, all items may have a different department, on the UI
  ||                     we must have a single default department                       
  */

	DECLARE @Taxable1 tinyint,
			@Taxable2 tinyint,
		    @ItemDepartmentKey int,
			@DefaultDepartmentKey int
		    
	select @DefaultDepartmentKey = @DepartmentKey

	--IF @Entity = 'tEstimate'
		SELECT @Taxable1 = 0
			   ,@Taxable2 = 0
			   
	IF @Entity = 'tTask'
		SELECT @Taxable1 = Taxable
			   ,@Taxable2 = Taxable2
		FROM   tTask (NOLOCK)
		WHERE  TaskKey = @EntityKey

	IF @Entity = 'tService'
		SELECT @Taxable1 = Taxable
			   ,@Taxable2 = Taxable2
			   ,@ItemDepartmentKey = DepartmentKey
		FROM   tService (NOLOCK)
		WHERE  ServiceKey = @EntityKey

	IF @Entity = 'tItem'
		SELECT @Taxable1 = Taxable
			   ,@Taxable2 = Taxable2
			   ,@ItemDepartmentKey = DepartmentKey
		FROM   tItem (NOLOCK)
		WHERE  ItemKey = @EntityKey

	IF @Entity = 'tWorkType'
		SELECT @Taxable1 = Taxable
			   ,@Taxable2 = Taxable2
			   ,@ItemDepartmentKey = DepartmentKey 
		FROM   tWorkType (NOLOCK)
		WHERE  WorkTypeKey = @EntityKey

	SELECT @Taxable1 = ISNULL(@Taxable1, 0)
		  ,@Taxable2 = ISNULL(@Taxable2, 0)

	-- Avoid 0, NULL values are valid 
	IF @ItemDepartmentKey = 0
		SELECT @ItemDepartmentKey = NULL
		
	IF @ItemDepartmentKey IS NOT NULL
		SELECT @DepartmentKey = @ItemDepartmentKey
							
	INSERT tBillingFixedFee
		(
		BillingKey,
		Entity,
		EntityKey,
		Percentage,
		Amount,
		Taxable1,
		Taxable2,
		DepartmentKey,
		DefaultDepartmentKey
		)

	VALUES
		(
		@BillingKey,
		@Entity,
		@EntityKey,
		@Percentage,
		@Amount,
		@Taxable1,
		@Taxable2,
		@DepartmentKey,
		@DefaultDepartmentKey
		)
	

	RETURN 1
GO
