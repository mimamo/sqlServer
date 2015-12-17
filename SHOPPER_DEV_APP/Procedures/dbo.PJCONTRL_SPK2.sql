USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCONTRL_SPK2]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCONTRL_SPK2]  @parm1 varchar (2) , @parm2 varchar (255) , @parm3 varchar (30)   as
select * from PJCONTRL
where control_type = @parm1
and control_data like @parm2
and control_code like @parm3
order by control_type,
control_code
GO
