USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBCON_SIK11]    Script Date: 12/21/2015 15:49:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBCON_SIK11]  @parm1 varchar (15)   as
select * from PJSUBCON
where    vendid      = @parm1
and    status_sub  <> 'C'
and    status_sub  <> 'D'
order by vendid, subcontract
GO
