USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_Spk8]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABHDR_Spk8] @parm1 varchar (10) ,@parm2 smalldatetime , @parm3 varchar (2)   as
select * from PJLABHDR
where    employee = @parm1 and
pe_date = @parm2  and
le_status = @parm3
	order by employee
GO
