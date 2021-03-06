USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x_DonovanAR_ValidateProjects]    Script Date: 12/21/2015 16:07:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[x_DonovanAR_ValidateProjects]

@ProjectSuccess bit output

as

--update the ValidProject field if the project in the work table
--can be found in the pjproj table
update x_DonovanAR_wrk set ValidProject=1
where SolProjectNbr in 
(
select p.project
from x_DonovanAR_wrk x
join pjproj p on x.SolProjectNbr=p.project
)

--test for error
if @@error<>0
begin
print 'Error updating ValidProject in x_DonovanAR_wrk'
return 1
end

--test to see if there are any records that did not pass the project validation
select top 1 SolProjectNbr from x_DonovanAR_wrk where ValidProject<>1

--if there are records, the validation was not successful 
if @@rowcount<>0
begin
set @ProjectSuccess=0
end
else
begin
set @ProjectSuccess=1
end

return 0
GO
