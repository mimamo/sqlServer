USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCONTRL_SDLL]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCONTRL_SDLL]  @parm1 varchar (2) , @parm2 varchar (30)   as
select control_data from PJCONTRL
where    control_type  = @parm1
and    control_code  = @parm2
order by control_type,
control_code
GO
