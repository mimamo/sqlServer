USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCONTRL_DPK0]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCONTRL_DPK0]  @parm1 varchar (2) , @parm2 varchar (30)   as
delete from PJCONTRL
where control_type = @parm1
and control_code =  @parm2
GO
