USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCODE_STMM]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCODE_STMM]  @parm1 varchar (4) , @parm2 varchar (30)   as
select * from PJCODE
where    code_type = @parm1
and    code_value LIKE @parm2
and    code_value <> ''
order by code_type,
code_value
GO
