USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_SMAXLINE]    Script Date: 12/21/2015 13:57:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEXPDET_SMAXLINE]  @parm1 varchar (10)   as
select max(linenbr) from PJEXPDET
where    docnbr     =  @parm1
GO
