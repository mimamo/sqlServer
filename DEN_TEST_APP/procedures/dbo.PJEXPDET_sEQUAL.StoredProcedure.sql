USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_sEQUAL]    Script Date: 12/21/2015 15:37:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEXPDET_sEQUAL]  @parm1 varchar (10) , @parm2 smallint  as
select * from PJEXPDET
where    pjexpdet.docnbr  =  @parm1
and PJEXPDET.linenbr  =  @parm2
order by pjexpdet.docnbr, pjexpdet.linenbr
GO
