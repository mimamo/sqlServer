USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCODE_SBMM]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCODE_SBMM]  @parm1 varchar (4) , @parm2 varchar (30)   as
select * from PJCODE
where    code_type    =    @parm1
and    code_value  = @parm2
and    code_value <> 'ARBI'
order by code_type,
code_value
GO
