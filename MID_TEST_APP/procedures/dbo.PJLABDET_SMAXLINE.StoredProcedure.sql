USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDET_SMAXLINE]    Script Date: 12/21/2015 15:49:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDET_SMAXLINE]  @parm1 varchar (10)   as
select max(linenbr) from PJLABDET
where    docnbr     =  @parm1
GO
