USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBCON_SALL]    Script Date: 12/21/2015 13:45:01 ******/
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
