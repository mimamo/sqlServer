USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_sempdtst]    Script Date: 12/21/2015 15:49:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABHDR_sempdtst] @parm1 varchar (10) ,@parm2 smalldatetime   as
select * from PJLABHDR
where    employee = @parm1 and
pe_date = @parm2
	order by employee, pe_date, le_status
GO
