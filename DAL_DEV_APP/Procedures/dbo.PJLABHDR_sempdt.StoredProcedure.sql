USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_sempdt]    Script Date: 12/21/2015 13:35:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABHDR_sempdt] @parm1 varchar (10) ,@parm2 smalldatetime   as
select * from PJLABHDR
where    employee = @parm1 and
pe_date = @parm2
	order by employee
GO
