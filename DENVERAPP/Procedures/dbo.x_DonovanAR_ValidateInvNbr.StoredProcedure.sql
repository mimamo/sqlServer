USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[x_DonovanAR_ValidateInvNbr]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[x_DonovanAR_ValidateInvNbr]

@InvNbrSuccess bit output

as

--update the ValidInvNbr field if the invoice number in the work table
--does not already exist in the ardoc table
update x_DonovanAR_wrk set ValidInvNbr=1
where InvoiceNumber not in 
(
select distinct refnbr
from ardoc
)

--test for error
if @@error<>0
begin
print 'Error updating ValidInvNbr in x_DonovanAR_wrk'
return 1
end

--test to see if there are any records that did not pass the invoice number validation
select top 1 InvoiceNumber from x_DonovanAR_wrk where ValidInvNbr<>1

--if there are records, the validation was not successful 
if @@rowcount<>0
begin
set @InvNbrSuccess=0
end
else
begin
set @InvNbrSuccess=1
end

return 0
GO
