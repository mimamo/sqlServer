USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x_DonovanAR_IMPORT]    Script Date: 12/21/2015 14:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[x_DonovanAR_IMPORT]

as
--declare variables 
declare @ReturnValue int
declare @ProjectSuccess bit
declare @MediaSuccess bit
declare @CustomerSuccess bit
declare @TermsSuccess bit
declare @InvNbrSuccess bit

--set the success variables to 1, it will be set to zero
--if any of the validations fail
set @ProjectSuccess=1
set @MediaSuccess=1
set @CustomerSuccess=1
set @TermsSuccess=1
set @InvNbrSuccess=1

begin tran

print 'Validating Projects...'
exec @ReturnValue = x_DonovanAR_ValidateProjects @ProjectSuccess output
if @ReturnValue<>0 goto abort

print 'Validating Media Types...'
exec @ReturnValue = x_DonovanAR_ValidateMedia @MediaSuccess output
if @ReturnValue<>0 goto abort

print 'Validating Customers...'
exec @ReturnValue = x_DonovanAR_ValidateCustomers @CustomerSuccess output
if @ReturnValue<>0 goto abort

print 'Validating Terms...'
exec @ReturnValue = x_DonovanAR_ValidateTerms @TermsSuccess output
if @ReturnValue<>0 goto abort

print 'Validating Invoice Numbers...'
exec @ReturnValue = x_DonovanAR_ValidateInvNbr @InvNbrSuccess output
if @ReturnValue<>0 goto abort

--test the success variables
if @ProjectSuccess=1 and @MediaSuccess=1 and @CustomerSuccess=1 and @TermsSuccess=1 and @InvNbrSuccess=1

begin

print 'All records have passed validation.'
print 'Import into Solomon commencing...'

print 'Retrieving A/R Batch Number...'
exec @ReturnValue = x_DonovanAR_GetARBatchNbr
if @ReturnValue<>0 goto abort

print 'Inserting ARDoc Records...'
exec @ReturnValue = x_DonovanAR_InsertARDoc
if @ReturnValue<>0 goto abort

print 'Inserting ARTran Records (Broadcast Payable)...'
exec @ReturnValue = x_DonovanAR_InsertARTran_BroadcastPayable
if @ReturnValue<>0 goto abort

print 'Inserting ARTran Records (COS)...'
exec @ReturnValue = x_DonovanAR_InsertARTran_COS
if @ReturnValue<>0 goto abort

print 'Inserting ARTran Records (Sales)...'
exec @ReturnValue = x_DonovanAR_InsertARTran_Sales
if @ReturnValue<>0 goto abort

print 'Inserting Batch Record...'
exec @ReturnValue = x_DonovanAR_InsertBatch
if @ReturnValue<>0 goto abort

print 'Inserting RefNbrs...'
exec @ReturnValue = x_DonovanAR_InsertRefNbr
if @ReturnValue<>0 goto abort

print 'Moving Records to the Archive...'
exec @ReturnValue = x_DonovanAR_MoveToArchive
if @ReturnValue<>0 goto abort

print 'Import was successful.'

end

else

begin
print 'Not all records have passed validation.'
print 'The import will not continue.'
end

commit tran
goto finish

abort:
rollback tran
print 'Import was not successful.  No AR records imported into Solomon.'

finish:
GO
