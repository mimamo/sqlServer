USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDET_SPK2]    Script Date: 12/21/2015 16:07:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDET_SPK2]  @parm1 varchar (10)   as
select * from PJLABDET
where    docnbr     =  @parm1
order by docnbr, linenbr
GO
