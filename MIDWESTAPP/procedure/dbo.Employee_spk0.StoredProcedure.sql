USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Employee_spk0]    Script Date: 12/21/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[Employee_spk0] @parm1 varchar (10)  as
select * from Employee
where EmpId = @parm1
order by EmpId
GO
