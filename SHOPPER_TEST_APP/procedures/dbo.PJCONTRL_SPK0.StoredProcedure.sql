USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCONTRL_SPK0]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCONTRL_SPK0]  @parm1 varchar (2) , @parm2 varchar (30)   as
select * from PJCONTRL
where control_type = @parm1
and control_code = @parm2
order by control_type,
control_code
GO
