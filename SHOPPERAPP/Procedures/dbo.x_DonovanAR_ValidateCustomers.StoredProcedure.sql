USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[x_DonovanAR_ValidateCustomers]    Script Date: 12/21/2015 16:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[x_DonovanAR_ValidateCustomers]

@CustomerSuccess bit output

as

--update the ValidCustomer field if the project in the work table
--can be found in the pjproj table and it has a customer
update x_DonovanAR_wrk set ValidCustomer=1
where SolProjectNbr in 
(
select p.project
from x_DonovanAR_wrk x
join pjproj p on x.SolProjectNbr=p.project
join customer c on p.customer=c.custid
)

--test for error
if @@error<>0
begin
print 'Error updating ValidCustomer in x_DonovanAR_wrk'
return 1
end

--test to see if there are any records that did not pass the project validation
select top 1 SolProjectNbr from x_DonovanAR_wrk where ValidCustomer<>1

--if there are records, return an error code 
if @@rowcount<>0
begin
set @CustomerSuccess=0
end
else
begin
set @CustomerSuccess=1
end

return 0
GO
