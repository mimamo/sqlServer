USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBCON_SCNCOS]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBCON_SCNCOS]  @parm1 varchar (16) , @parm2 varchar (16)   as
select * from PJSUBCON
where    project     =    @parm1 and
subcontract like @parm2 and
status_sub  <>   ''
order by project, subcontract
GO
