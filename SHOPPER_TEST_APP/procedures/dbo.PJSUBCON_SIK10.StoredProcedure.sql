USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBCON_SIK10]    Script Date: 12/21/2015 16:07:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBCON_SIK10]  @parm1 varchar (15)   as
select * from PJSUBCON
where    vendid      = @parm1
order by vendid, subcontract
GO
