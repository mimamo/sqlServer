USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCODE_SALL]    Script Date: 12/21/2015 13:57:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCODE_SALL]  @parm1 varchar (4) , @parm2 varchar (30)   as
select * from PJCODE
where    code_type    LIKE @parm1
and    code_value   LIKE @parm2
order by code_type,
code_value
GO
