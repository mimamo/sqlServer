USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignAllocateHours]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignAllocateHours]
	(
	@AvailableHours decimal(24,4)
	)
AS
	SET NOCOUNT ON

  /*
  || When     Who Rel    What
  || 09/27/10 GHL 10.535 Created for new task assign method by service. General allocation routine.
  */
	/* Assume done in calling function
	create table #alloc (EntityKey int null, AllocatedHours decimal(24, 4) null, Weight int null)
	*/

	if (select count(*) from #alloc) = 0
		return 1

	update #alloc 
	set    Weight = isnull(Weight, 1)

	update #alloc 
	set    Weight = 1
	where  Weight = 0

	declare @SumWeights decimal(24,4)
	select @SumWeights = cast ((select sum(Weight) from #alloc) as decimal(24,4) ) 

	-- allocate hours based on some weight
	update #alloc
	set    AllocatedHours = ROUND(
	                         (@AvailableHours * CAST(Weight AS DECIMAL(24,4)) / @SumWeights )
							, 2)

	-- Now protect against rounding errors
	declare @SumAllocatedHours decimal(24,4)
	declare @DiffAllocatedHours decimal(24,4)
	declare @EntityKey int

	select @SumAllocatedHours = sum(AllocatedHours) from #alloc
	select @DiffAllocatedHours = @AvailableHours - @SumAllocatedHours 

	if (@DiffAllocatedHours <> 0)
	begin
		select @EntityKey = MAX(EntityKey)
		from   #alloc
	
		update #alloc
		set    AllocatedHours = AllocatedHours + @DiffAllocatedHours 
		where  EntityKey = @EntityKey
	end	

	RETURN 1
GO
