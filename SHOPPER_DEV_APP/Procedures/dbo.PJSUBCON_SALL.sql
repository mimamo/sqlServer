USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBCON_SALL]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBCON_SALL]  @parm1 varchar (16) , @parm2 varchar (16)   as
select * from PJSUBCON
where    project = @parm1 and
subcontract like @parm2
order by project, subcontract
GO
