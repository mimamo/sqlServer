USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_Spk81]    Script Date: 12/21/2015 13:57:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABHDR_Spk81] @parm1 varchar (10) ,@parm2 smalldatetime as
select * from PJLABHDR
where    employee = @parm1 and
pe_date = @parm2  and
le_status in ('A','I','C','R','T')
	order by employee
GO
