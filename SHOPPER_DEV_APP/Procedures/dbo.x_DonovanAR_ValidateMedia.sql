USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x_DonovanAR_ValidateMedia]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[x_DonovanAR_ValidateMedia]

@MediaSuccess bit output

as

--update the ValidMedia field if the media type in the work table
--can be found in the x_DonovanAR_MediaAcctXRef table
update x_DonovanAR_wrk set ValidMedia=1
where MediaType in 
(
select m.MediaType
from x_DonovanAR_wrk x
join x_DonovanAR_MediaAcctXRef m on x.MediaType=m.MediaType
)

--test for error
if @@error<>0
begin
print 'Error updating ValidMedia in x_DonovanAR_wrk'
return 1
end

--test to see if there are any records that did not pass the project validation
select top 1 SolProjectNbr from x_DonovanAR_wrk where ValidMedia<>1

--if there are records, return an error code 
if @@rowcount<>0
begin
set @MediaSuccess=0
end
else
begin
set @MediaSuccess=1
end

return 0
GO
