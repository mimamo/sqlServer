USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRANEX_sID11]    Script Date: 12/21/2015 16:07:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRANEX_sID11] @parm1 varchar (30)   as
select * from PJTRANEX
where TR_ID11 = @parm1
	order by TR_ID11
GO
