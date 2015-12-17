USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCODE_SDATA1]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCODE_SDATA1]  @parm1 varchar (4) , @parm2 varchar (30) , @parm3 varchar (30) as
select * from PJCODE
where    code_type    =    @parm1
and    data1 like @parm2
and   code_value like @parm3
order by code_value
GO
