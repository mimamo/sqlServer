USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBCON_SCOMM2]    Script Date: 12/21/2015 15:49:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBCON_SCOMM2]  @parm1 varchar (16) , @parm2 varchar (16)   as
select * from PJSUBCON
where    project like @parm1 and
subcontract like @parm2 and
status_sub = 'A'
order by project, subcontract
GO
