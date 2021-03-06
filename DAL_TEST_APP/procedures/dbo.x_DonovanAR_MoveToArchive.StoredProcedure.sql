USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x_DonovanAR_MoveToArchive]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[x_DonovanAR_MoveToArchive]

as

--move the records from the work table to the archive
insert x_DonovanAR_hist
select * from x_DonovanAR_wrk

--test for errors
if @@error<>0
begin
print 'Error Inserting into x_DonovanAR_hist'
return 1
end

--clear out the work table
delete from x_DonovanAR_wrk

--test for errors
if @@error<>0
begin
print 'Error Deleting x_DonovanAR_wrk'
return 1
end

return 0
GO
