USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x_DonovanAR_GetARBatchNbr]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[x_DonovanAR_GetARBatchNbr]

as

--make sure that there are rows in the work table before proceeding
select SolProjectNbr from x_DonovanAR_wrk

if @@rowcount<>0

begin

	--make sure that the SolBatNbr field is blank
	select top 1 SolBatNbr from x_DonovanAR_wrk where SolBatNbr<>''

	--if there is already a SolBatNbr, no need to get another one
	if @@rowcount=0 

	begin

		--variable to hold the last batch nbr
		declare @BatNbr varchar(10)

		--retrieve the last batch nbr from arsetup
		set @BatNbr=(select LastBatNbr from ARSetup)

		--increment the last batch nbr by 1
		set @BatNbr=@BatNbr+1
		print 'A/R Batch Number: ' + @BatNbr

		--update the last batch nbr in arsetup
		update ARSetup set LastBatNbr=@BatNbr

		--test for error
		if @@error<>0
		begin
		print 'Error updating LastBatNbr in ARSetup'
		return 1
		end

		--update the work table to include the Solomon batch nbr
		update x_DonovanAR_wrk set SolBatNbr=@BatNbr

		--test for error
		if @@error<>0
		begin
		print 'Error updating SolBatNbr in x_DonovanAR_wrk'
		return 1
		end

	end

end

return 0
GO
